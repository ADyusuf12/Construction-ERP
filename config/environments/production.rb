require "active_support/core_ext/integer/time"

Rails.application.configure do
  # --- CORE PERFORMANCE ---
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # --- SECURITY & SSL ---
  config.assume_ssl = true
  config.force_ssl = true

  # --- LOGGING ---
  config.log_tags = [ :request_id ]
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.silence_healthcheck_path = "/up"

  # --- DATABASE & QUEUE (Solid Queue/Cache) ---
  config.cache_store = :solid_cache_store
  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue } }

  # --- MAILER SETUP (Bespoke/Dynamic) ---
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp

  # Pulls host from Render/Server Env (e.g., Earmark-erp.com or earmark-client.com)
  config.action_mailer.default_url_options = {
    host: ENV.fetch("APP_HOST", "localhost"),
    protocol: "https"
  }

  config.action_mailer.smtp_settings = {
    user_name: Rails.application.credentials.dig(:smtp, :user_name),
    password: Rails.application.credentials.dig(:smtp, :password),
    address: ENV.fetch("SMTP_ADDRESS", "smtp.gmail.com"),
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }

  # --- STORAGE ---
  config.active_storage.service = ENV.fetch("ACTIVE_STORAGE_SERVICE", "local").to_sym

  # --- I18N & ASSETS ---
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]

  # --- HOST AUTHORIZATION ---
  if ENV["APP_HOST"].present?
    config.hosts << ENV["APP_HOST"]
    config.hosts << /.*\.#{Regexp.escape(ENV["APP_HOST"])}/
  end
end
