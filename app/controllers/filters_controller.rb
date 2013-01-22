class FiltersController < ApplicationController
  def index
    if filters.valid?
      render :json => filters
    else
      head :unprocessable_entity
    end
  end

  private

  def filters
    @filters ||= ApplicationEventsFilterDecorator.new(application, params.slice(:model, :type))
  end
end
