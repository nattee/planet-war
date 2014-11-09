class MainController < ApplicationController
  before_filter :authenticated, only: [:dashboard, :challenge_list, :challenge_confirm, :do_challenge]

  def home
    redirect_to main_dashboard_path if session[:user_id]
  end

  def dashboard
    user = User.find(session[:user_id])
    @submission = Submission.where(user_id: user.id).paginate(:page => params[:spage], :per_page => 10)
    @match = Match.select("matches.*")
                  .joins('INNER JOIN submissions ON ' +
                            'matches.p1_sub_id = submissions.id OR '+
                            'matches.p2_sub_id = submissions.id ' + 
                            'INNER JOIN users ON submissions.user_id = users.id')
                  .where("users.id = ?",user.id)
                  .order("matches.id DESC")
                  .group(:id)
                  .paginate(page: params[:mpage])
  end

  def challenge_list
    #@user = User.find(
    #  :select => "users.*,count(*) as submission_count",
    #  :where => "submission_count > 0",
    #  :joins => "INNER JOIN submissions on users.id = submissions.user_id and submissions.state = 2",
    #  :group => "users.id"
    #)
    @user = User.select("users.*,count(*) as submission_count")
                .joins("INNER JOIN submissions on users.id = submissions.user_id and submissions.state >= 2")
                .group(:id).having("submission_count > 0")
  end

  def challenge_confirm
    #validate user submission
    @s = Submission.where("user_id = ? and state >= 2",session[:user_id]).order(id: :desc).first
    unless @s then
      flash[:error] = "you don't have eligible submission"
      return redirect_to main_dashboard_path
    end

    @opp_s = Submission.where("user_id = ? and state >= 2",params[:id]).order(id: :desc).first
    unless @opp_s then
      flash[:error] = "Opponent doesn't have eligible submission"
      return redirect_to main_dashboard_path
    end

  end

  def do_challenge
    s1 = Submission.find(params[:p1_id])
    s2 = Submission.find(params[:p2_id])
    user = User.find(session[:user_id])
    if (s1.user != user) or (s1.state < 2) then
      flash[:error] = "You don't have permission to challenge"
      return redirect_to main_dashboard_path
    end
    if (s2.state < 2) then 
      flash[:error] = "Opponent doesn't have eligible submission"
      return redirect_to main_dashboard_path
    end
    #create match
    m = Match.new
    m.p1_sub_id = params[:p1_id]
    m.p2_sub_id = params[:p2_id]
    m.map = Map.get_random
    m.save

    #create task
    t = Task.new
    t.match_id = m.id
    t.save

    flash[:notice] = "A challenge is scheduled. It will take sometime before match is completed."
    redirect_to main_challenge_list_path
  end
end
