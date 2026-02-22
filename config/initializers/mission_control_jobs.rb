# config/initializers/mission_control_jobs.rb
require "mission_control/jobs"

Rails.application.configure do
  u = ENV["JOBS_USER"] || Rails.application.credentials.dig(:mission_control, :jobs, :user) || "admin"
  p = ENV["JOBS_PASSWORD"] || Rails.application.credentials.dig(:mission_control, :jobs, :password)

  # This will show up in your Render logs so you can see which one it picked
  Rails.logger.info "MISSION CONTROL AUTH: User is #{u}, Password starts with #{p&.first(3)}..."

  config.mission_control.jobs.authentication = { user: u, password: p }
  config.mission_control.jobs.adapters = [ :solid_queue ]
end
