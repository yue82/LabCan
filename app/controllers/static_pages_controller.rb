class StaticPagesController < ApplicationController
  before_action :logged_out_user, only: [:home]
  def home
  end

  private
  def logged_out_user
    if logged_in?
      redirect_to users_url
    end
  end

end
