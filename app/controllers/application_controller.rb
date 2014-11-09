class ApplicationController < ActionController::Base
  protect_from_forgery


  def authenticated
    unless session[:user_id] then
      flash[:error] = "You need to login"
      redirect_to root_path
    end
  end

end
