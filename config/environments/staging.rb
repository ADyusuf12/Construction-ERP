# config/environments/staging.rb
Rails.application.configure do
  # --- CORE PERFORMANCE (Matches Production) ---
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # --- ASSETS ---
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.assets.js_compressor = :uglifier
  config.assets.compile = false

  # --- LOGGING (Debug Level for easier troubleshooting) ---
  config.log_level = :debug
  config.log_tags = [ :request_id ]
  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # --- STORAGE ---
  config.active_storage.service = ENV.fetch("ACTIVE_STORAGE_SERVICE", "local").to_sym

  # --- MAILER SETUP (Dynamic) ---
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true

  # Pulls the staging URL dynamically from Render Env
  config.action_mailer.default_url_options = {
    host: ENV.fetch("STAGING_APP_HOST", "staging.earmark-erp.com"),
    protocol: "https"
  }

  config.action_mailer.smtp_settings = {
    user_name: Rails.application.credentials.dig(:smtp, :user_name),
    password: Rails.application.credentials.dig(:smtp, :password),
    address: "smtp.gmail.com",
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }

  # --- DATABASE ---
  config.active_record.dump_schema_after_migration = false

  # --- HOST AUTHORIZATION ---
  if ENV["STAGING_APP_HOST"].present?
    config.hosts << ENV["STAGING_APP_HOST"]
  end
end
