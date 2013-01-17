class ApplicationEventsDecorator
  include Decorator

  def as_json(*)
    filter

    @events.collect {|event| EventDecorator.new(event).as_json }
  end

  private

  def ids
    Hat.redis {|r| r.hvals(key) }.map {|v| v.split(':').last }
  end

  def key
    k = "applications:#{@item.id}:events"
    (k << ":#{@options[:env]}") unless @options[:env].nil?
    k
  end

  def page
    @page ||= @options[:page].to_i
  end

  def filter
    @events = @item.events.order("generated_at DESC").limit(30)

    @events = @events.offset((page - 1) * 30) if page > 1

    if (type = @options.fetch(:model_type, false))
      @events = @events.where(:model_type => type.to_s)
    end

    if (id = @options.fetch(:model_id, false))
      @events = @events.where(:model_id => id.to_s)
    end

    if (klass = @options.fetch(:klass, false))
      @events = @events.where(:klass => klass.to_s)
    end

    @events = @events.where(:id => ids) unless (type || id || klass)
  end
end
