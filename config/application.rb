require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

Dotenv.load(".env.#{ENV["RAILS_ENV"] || Rails.env}") if defined?(Dotenv)

module EarmarkSystems
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])

    config.active_job.queue_adapter = :solid_queue
    config.mission_control.jobs.base_controller_class = "AdminController"
    config.autoload_paths << Rails.root.join("app/services")
  end
end
