class FiltersController < ApplicationController
  before_filter :load_application

  def index
    decorator = ApplicationEventsFilterDecorator.new(@app, params.slice(:model, :type))

    if decorator.valid?
      render :json => decorator
    else
      head :unprocessable_entity
    end
  end
end
