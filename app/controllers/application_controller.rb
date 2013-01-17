class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate!

  def user
    @user ||= begin
      User.where(:token => cookies.signed[:token]).first.tap do |user|
        (params[:user] = user) if user.present?
      end
    end
  end

  helper_method :user

  def user?
    user.present?
  end

  helper_method :user?

  def set_cookie
    cookies.signed[:token] = {
        :value => @item.token,
        :expires => 3.weeks.from_now
    }

    true
  end

  def load_application
    @app = user.applications.find(params[:application_id])
  end

  helper_method :load_application

  def render_error
    if params[:action] == "create"
      render :json => {:errors => @item.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  private

  def authenticate!
    unless user?
      redirect_to new_session_path
    end
  end
end
