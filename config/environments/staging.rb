# config/environments/staging.rb
Rails.application.configure do
  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot.
  config.eager_load = true

  # Full error reports are disabled (like production).
  config.consider_all_requests_local = false

  # Enable/disable caching. Same as production.
  config.action_controller.perform_caching = true

  # Serve static files if the env var is set (Render sets RAILS_SERVE_STATIC_FILES).
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Log level — more verbose than production for debugging.
  config.log_level = :debug

  # Prepend all log lines with request ID.
  config.log_tags = [ :request_id ]

  # Use default logging formatter so PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Log to STDOUT if RAILS_LOG_TO_STDOUT is set (Render does this).
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Active Storage service (local or cloud).
  config.active_storage.service = :local

  # Action Mailer (you can adjust for staging mail testing).
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true

  # Don’t dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
