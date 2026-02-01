class AdminController < ActionController::Base
  http_basic_authenticate_with(
    name: ENV.fetch("JOBS_USER"),
    password: ENV.fetch("JOBS_PASSWORD")
  )
end
