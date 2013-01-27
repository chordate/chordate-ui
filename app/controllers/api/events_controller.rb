class Api::EventsController < ApiController
  before_filter -> { params[:batch] = [] unless params[:batch].present? }, :only => [:create]

  def create
    events = Api::ApplicationEventsDecorator.new(application)

    render :json => events.create(params[:batch]), :status => :created
  end

  def update
    application.events.find(params[:id]).tap do |event|
      if event.update_attributes(params.slice(:status, :flagged))
        render :json => EventDecorator.new(event)
      else
        render :json => Api::ErrorDecorator.new(422, event.errors.full_messages), :status => 422
      end
    end
  end
end
