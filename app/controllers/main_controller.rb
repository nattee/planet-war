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
end
