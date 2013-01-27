class Api::ApplicationEventsDecorator
  def initialize(application)
    @application = application
  end

  def create(events)
    transact do
      events.collect do |event|
        (event = @application.events.create(event)).persisted? ?
          EventDecorator.new(event) : error(event)
      end
    end if events.any?
  end

  def error(event)
    Api::ErrorDecorator.new(422, event.errors.full_messages)
  end
end
