require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module HamzisSystems
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])

    # Load environment-specific dotenv file
    Dotenv.load(".env.#{Rails.env}") if defined?(Dotenv)

    config.active_job.queue_adapter = :solid_queue
    config.mission_control.jobs.base_controller_class = "AdminController"
  end
end
