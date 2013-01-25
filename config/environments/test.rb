ChordateUi::Application.configure do
  config.eager_load = false
  config.cache_classes = true

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  config.action_dispatch.show_exceptions = false

  config.action_controller.allow_forgery_protection = false

  config.action_mailer.delivery_method = :test
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false

  config.active_support.deprecation = :stderr

  config.action_mailer.default_url_options = { :host => "localhost:9292" }
end
