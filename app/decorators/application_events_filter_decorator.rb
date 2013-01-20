class ApplicationEventsFilterDecorator
  include Decorator

  TYPES = %w(klass model_type)

  def valid?
    return true if (@options[:model] == "event" && TYPES.include?(@options[:type]))

    false
  end

  def as_json(*)
    return [] unless valid?

    @item.events.group(@options[:type]).count.collect {|fk| FilterKlassDecorator.new(fk).as_json }
  end
end
