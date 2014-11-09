class SessionsController < ApplicationController
  def create
    if user = User.authenticate(params[:login], params[:password])
      session[:user_id] = user.id
      redirect_to controller: :main, action: :dashboard
    else
      flash[:notice] = "Invalid username/password"
      redirect_to controller: :main, action: :home
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
