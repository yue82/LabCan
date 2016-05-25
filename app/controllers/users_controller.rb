class UsersController < ApplicationController
  before_action :logged_out_user, only: [:new, :create]
  before_action :logged_in_user, only: [:show, :edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update, :update_check_token]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      Attendance.new(user_id: @user.id).save
      @user.update_check_token
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if user_params[:check_token]
      @user.update_check_token
      flash[:success] = "Token updated"
      redirect_to @user
    elsif @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.where(activated: true)
    @user = current_user
  end

  def destroy
    @user = User.find(params[:id])
    @attendance = @user.attendance
    @user.destroy
    flash[:success] = "\"" + @user.name + "\" deleted"
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit(:name, :email,
                                 :password, :password_confirmation,
                                 :user_icon, :comment, :check_token)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_path
    end
  end

  def logged_out_user
    if logged_in?
      redirect_to users_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
