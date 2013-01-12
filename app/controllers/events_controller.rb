class EventsController < ApplicationController
  before_filter lambda { @app = user.applications.find(params[:application_id]) }

  def index
    respond_to do |type|
      type.html { }
      type.json {
        render :json => filtered_events
      }
    end
  end

  private

  def filtered_events
    events = @app.events.select('DISTINCT ON (klass) klass, events.*').
      order('klass, generated_at DESC').limit(30).sort {|x,y| y.generated_at <=> x.generated_at }

    events.collect {|event| EventDecorator.new(event) }
  end
end
