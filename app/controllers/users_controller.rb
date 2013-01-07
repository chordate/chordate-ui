class UsersController < ApplicationController
  skip_before_filter :authenticate!, :only => [:new, :create]

  def new
  end

  def create
    @item = User.new(params.slice(:name, :email, :password))

    if (decorator = UserDecorator.new(@item)).save
      set_cookie && (render :json => decorator, :status => :created)
    else
      render :json => {:errors => @item.errors.full_messages}, :status => :unprocessable_entity
    end
  end
end
