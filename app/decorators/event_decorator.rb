class EventDecorator
  include Decorator

  allow :generated_at, :env, :klass, :message, :model_type, :model_id, :action
end
