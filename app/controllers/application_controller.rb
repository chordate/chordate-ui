class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate!

  def user
    @user ||= begin
      User.where(:token => _user_token).first.tap_if(:present?) do |user|
        params[:user] = user
      end
    end
  end

  def user?
    user.present?
  end

  def set_cookie
    cookies.signed[:token] = {
      :value => @item.token,
      :expires => 3.weeks.from_now
    }

    true
  end

  def application
    @application ||= user.applications.find(params[:application_id])
  end

  def render_error
    if params[:action] == "create"
      render :json => {:errors => @item.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  helper_method :user, :user?, :application

  private

  def authenticate!
    unless user?
      redirect_to new_session_path
    end
  end

  def _user_token
    cookies.signed[:token].presence || params[:token]
  end
end
