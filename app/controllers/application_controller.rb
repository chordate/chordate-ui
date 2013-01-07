class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate!

  def current_user
    @current_user ||= User.where(:token => cookies.signed[:token]).first
  end

  helper_method :current_user

  def set_cookie
    cookies.signed[:token] = {
        :value => @item.token,
        :expires => 3.weeks.from_now
    }

    true
  end

  private

  def authenticate!
    unless current_user.present?
      redirect_to new_session_path
    end
  end
end
