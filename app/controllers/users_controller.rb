class UsersController < ApplicationController
  before_action :logged_out_user, only: [:new, :create]
  before_action :logged_in_user, only: [:show, :edit, :update, :index, :destroy, :checkin, :checkout]
  before_action :correct_user, only: [:edit, :update, :update_check_token]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
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
    if !params[:user]
      flash[:danger] = "No updates"
      render 'edit'
    elsif user_params[:temp_icon]
      if @user.update_attribute(:temp_icon, user_params[:temp_icon])
        render 'icon_edit'
      else
        flash[:danger] = "Fail"
        render 'edit'
      end
    elsif user_params[:user_icon]
      @user.update_image_infos(user_params)
      if @user.update_attribute(:user_icon, @user.temp_icon)
        flash[:success] = "Icon updated"
        redirect_to @user
      else
        flash[:danger] = "Fail"
        render 'icon_edit'
      end
    elsif user_params[:check_token]
      @user.update_check_token
      flash[:success] = "Token updated"
      redirect_to @user
    elsif user_params[:comment]
      if @user.update_attributes(user_params)
        flash[:success] = "Comment updated"
        redirect_to @user
      else
        render 'show'
      end
    elsif @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def icon_edit
    @user = User.find(params[:id])
  end

  def icon_update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Icon updated"
      redirect_to @user
    else
      render 'icon_edit'
    end
  end

  def show
    @user = User.find(params[:id])
    @user_comment = @user.comment
  end

  def index
    @users = User.where(activated: true)
    @user = current_user
    @user_num = User.where(activated: true).count
    @checkin_num = Attendance.where(attend: true).count
  end

  def destroy
    @user = User.find(params[:id])
    @attendance = @user.attendance
    @user.destroy
    flash[:success] = "\"" + @user.name + "\" deleted"
    redirect_to users_url
  end

  def checkin
    store_prev_location
    @user = current_user
    status, res = @user.attendance.checkin
    flash[status] = res[:msg]
    redirect_back_or users_url
  end

  def checkout
    store_prev_location
    @user = current_user
    status, res = @user.attendance.checkout
    if status == :success
      announce_last(last_one_user)
    end
    flash[status] = res[:msg]
    redirect_back_or users_url
  end

  private
  def user_params
    params.require(:user).permit(:name, :email,:slack_channel,
                                 :password, :password_confirmation,
                                 :temp_icon, :comment, :check_token,
                                 :user_icon, :image_x, :image_y, :image_w, :image_h)
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
