class MainController < ApplicationController
  def home
  end

  def dashboard
    user = User.find(session[:user_id])
    @submission = Submission.where(user_id: user.id).paginate(:page => params[:spage], :per_page => 2)
    @match = Match.joins('INNER JOIN submissions ON ' +
                            'matches.p1_sub_id = submissions.id OR '+
                            'matches.p2_sub_id = submissions.id ' + 
                            'INNER JOIN users ON submissions.user_id = users.id').
                            where("users.id = ?",user.id).paginate(page: params[:mpage])
  end

  def challenge_list
    @user = User.find(
      :all,
      :select => "users.*,count(*) as submission_count",
      :joins => "INNER JOIN submissions on users.id = submissions.user_id and submissions.state = 2",
      :group => "users.id",
      :where => "submission_count > 0"
    )
  end

  def challenge
    #validate user submission
    s = Submission.where(user: session[:user_id],state: 2).order(:id).first
    if s.size == 0 then
      flash[:error] = "you don't have eligible submission"
      redirect_to dashboard_path
    end

    opp_s = Submission.where(user: params[:opponent],state: 2).order(:id).first
    if opp_s.size == 0 then
      flash[:error] = "Opponent doesn't have eligible submission"
      redirect_to dashboard_path
    end

    #create match
    m = Match.new
    m.p1_sub_id = s.id
    m.p2_sub_id = opp_s.id
    m.map = "map#{rand(100)+1}.txt"
    m.save

    #create task
    t = Task.new
    t.match_id = m.id
    t.save
  end
end
