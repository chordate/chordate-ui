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
    options = params.slice(:env, :page).symbolize_keys

    ApplicationEventsDecorator.new(@app, options)
  end
end

__END__

def filtered_events # via SQL
  events = @app.events.select('DISTINCT ON (klass) klass, events.*').
    order('klass, generated_at DESC').limit(30).sort {|x,y| y.generated_at <=> x.generated_at }
end
