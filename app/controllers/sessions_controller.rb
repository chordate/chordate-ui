class SessionsController < ApplicationController
  skip_before_filter :authenticate!, :only => [:new, :create]

  def new
  end

  def create
    @item = Session.new(params.slice(:email, :password))

    if @item.login
      set_cookie && (render :json => {}, :status => :created)
    else
      render :json => {:errors => I18n.t("sessions.create.error")}, :status => :unprocessable_entity
    end
  end
end
