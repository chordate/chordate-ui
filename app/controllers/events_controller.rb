class EventsController < ApplicationController
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
    options = params.slice(:page, :env, :klass, :model_type, :model_id)

    ApplicationEventsDecorator.new(application, options)
  end
end

__END__

def filtered_events # via SQL
  events = application.events.select('DISTINCT ON (klass) klass, events.*').
    order('klass, generated_at DESC').limit(30).sort {|x,y| y.generated_at <=> x.generated_at }
end
