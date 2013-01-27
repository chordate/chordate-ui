class Api::EventsController < ApiController
  before_filter -> { params[:batch] = [] unless params[:batch].present? }, :only => [:create]

  def create
    events = Api::ApplicationEventsDecorator.new(application)

    render :json => events.create(params[:batch]), :status => :created
  end
end
