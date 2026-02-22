require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

Dotenv.load(".env.#{ENV["RAILS_ENV"] || Rails.env}") if defined?(Dotenv)

module EarmarkSystems
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])

    config.autoload_paths << Rails.root.join("app/services")
  end
end
