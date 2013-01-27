class EventDecorator
  include Decorator

  allow :generated_at, :env, :klass, :message, :source, :model_type, :model_id, :task
end
