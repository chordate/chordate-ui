class UsersController < ApplicationController
  skip_before_filter :authenticate!, :only => [:new, :create]

  def new
  end

  def create
    @item = User.new(params.slice(:name, :email, :password))

    if (decorator = UserDecorator.new(@item)).save
      set_cookie && (render :json => decorator, :status => :created)
    else
      render_error
    end
  end

  def index
    render :json => UserDecorator.many(application.users.order("application_users.created_at"))
  end
end
