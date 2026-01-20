RSpec.configure do |config|
  # Default to test adapter and clear jobs before each example
  config.before(:each) do
    ActiveJob::Base.queue_adapter = :test
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
    ActiveJob::Base.queue_adapter.performed_jobs.clear
  end

  # If you want request specs to run jobs inline (apply movements immediately),
  # tag them with `:inline_jobs` or enable for type: :request
  config.around(:each, :inline_jobs) do |example|
    previous = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :inline
    example.run
    ActiveJob::Base.queue_adapter = previous
  end
end
