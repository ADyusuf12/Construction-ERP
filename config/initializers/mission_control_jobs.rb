# config/initializers/mission_control_jobs.rb
require "mission_control/jobs"

Rails.application.configure do
  u = ENV["JOBS_USER"].presence || Rails.application.credentials.dig(:mission_control, :jobs, :user) || "admin"
  p = ENV["JOBS_PASSWORD"].presence || Rails.application.credentials.dig(:mission_control, :jobs, :password) || "password"

  config.mission_control.jobs.authentication = { user: u, password: p }
  config.mission_control.jobs.adapters = [ :solid_queue ]
end
