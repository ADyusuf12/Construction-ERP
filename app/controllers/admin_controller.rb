class AdminController < ActionController::Base
  http_basic_authenticate_with(
    name: ENV["JOBS_USER"],
    password: ENV["JOBS_PASSWORD"]
  )
end
