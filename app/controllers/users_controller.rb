class UsersController < ApplicationController

  layout "external"

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Created Account"
    else
      render :new
      flash[:alert] = "Sorry...something went wrong"
    end
  end

  #used to show all of the users auctions and bids they've made
  def show
    @user = User.find params[:id]
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end


end
