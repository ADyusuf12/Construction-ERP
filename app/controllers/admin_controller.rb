class AdminController < ActionController::Base
  if Rails.env.development?
    http_basic_authenticate_with(
      name: ENV["JOBS_USER"],
      password: ENV["JOBS_PASSWORD"]
    )
  end
end
