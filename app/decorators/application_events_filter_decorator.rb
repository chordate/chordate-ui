class ApplicationEventsFilterDecorator
  include Decorator

  def valid?
    return true if (@options[:model] == "event" && @options[:type] == "klass")

    false
  end

  def as_json(*)
    return [] unless valid?

    @item.events.group(:klass).count.collect {|fk| FilterKlassDecorator.new(fk).as_json }
  end
end
