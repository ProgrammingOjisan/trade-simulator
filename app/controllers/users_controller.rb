class UsersController < ApplicationController
  def index
    @users = User.order(id: :desc).page(params[:page]).per(8)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new
    
    if @user.save
      flash[:success] = "Succeeded"
      redirect_to @user
    else
      flash.now[:danger] = "Failed"
      render "new"
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
