class ApplicationEventsDecorator
  include Decorator

  def as_json(*)
    ids = Hat.redis {|r| r.hvals(key) }.map {|v| v.split(':').last }

    events = Event.where(:id => ids).order("generated_at DESC").limit(30)

    page = @options[:page].to_i
    events = events.offset(page * 30) if page > 1

    events.collect! {|event| EventDecorator.new(event).as_json }
    events
  end

  private

  def key
    k = "applications:#{@item.id}:events"
    (k << ":#{@options[:env]}") unless @options[:env].nil?
    k
  end
end
