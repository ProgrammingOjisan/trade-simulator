class UsersController < ApplicationController
before_action :require_user_logged_out, only: [:new, :create]

  def index
    @users = User.order(id: :desc).page(params[:page]).per(8)
  end

  def show
    @user = User.find(params[:id])
    @favoritings = @user.favoriting.order(id: :desc).page(params[:page]).per(4)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
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
