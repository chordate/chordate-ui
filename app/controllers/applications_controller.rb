class ApplicationsController < ApplicationController
  def new
  end

  def index
  end

  def create
    @item = Application.new(params.slice(:name, :user))

    if(decorator = ApplicationDecorator.new(@item)).save
      render :json => decorator, :status => :created
    else
      render_error
    end
  end

  def show
    @item = user.applications.find(params[:id])
  end
end
