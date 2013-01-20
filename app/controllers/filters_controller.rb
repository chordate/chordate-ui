class FiltersController < ApplicationController
  before_filter :load_application

  def index
    if filters.valid?
      render :json => filters
    else
      head :unprocessable_entity
    end
  end

  private

  def filters
    @filters ||= ApplicationEventsFilterDecorator.new(@app, params.slice(:model, :type))
  end
end
