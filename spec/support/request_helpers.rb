# spec/support/request_helpers.rb
module RequestHelpers
  def html_headers
    { "ACCEPT" => "text/html" }
  end

  def referer_headers(path)
    { "HTTP_REFERER" => path, "ACCEPT" => "text/html" }
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
