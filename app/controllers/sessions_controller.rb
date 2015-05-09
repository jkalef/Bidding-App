class SessionsController < ApplicationController

  layout "external"

  def new
  end

  def create
    @user = User.find_by_email params[:email]
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path, notice: "logged in successfully"
    else
      flash[:alert] = "Invalid username/password"
      redirect_to new_session_path
    end
  end


  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out successfully"
    redirect_to root_path
  end

end
