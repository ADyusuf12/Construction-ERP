require "mission_control/jobs"

Rails.application.configure do
  # This order: Check ENV first (Render), then Credentials (Local), then Default
  config.mission_control.jobs.authentication = {
    user: ENV["JOBS_USER"] || Rails.application.credentials.dig(:mission_control, :jobs, :user) || "admin",
    password: ENV["JOBS_PASSWORD"] || Rails.application.credentials.dig(:mission_control, :jobs, :password)
  }

  config.mission_control.jobs.adapters = [ :solid_queue ]
end
