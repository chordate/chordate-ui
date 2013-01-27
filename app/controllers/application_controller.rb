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

  def account
    @account ||= begin
      (user? && user.account ||
        application? && application.account).tap_if(:present?) do |account|
          params[:account] = account
      end
    end
  end

  def account?
    account.present?
  end

  def application
    @application ||= begin
      if (app_id = params[:application_id].presence)
        params[:application] = (user? ? user.applications : Application).find(app_id)
      end
    end
  end

  def application?
    application.present?
  end

  def set_cookie
    cookies.signed[:token] = {
      :value => @item.token,
      :expires => 3.weeks.from_now
    }

    true
  end

  def render_error
    if params[:action] == "create"
      render :json => {:errors => @item.errors.full_messages}, :status => 422
    end
  end

  helper_method :user, :user?, :account, :account?, :application, :application?

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
