class Rack::Attack
  # Throttle login attempts by IP
  throttle("logins/ip", limit: 5, period: 60.seconds) do |req|
    if req.path == "/users/sign_in" && req.post?
      req.ip
    end
  end

  # Throttle login attempts by email param
  throttle("logins/email", limit: 5, period: 60.seconds) do |req|
    if req.path == "/users/sign_in" && req.post?
      req.params["user"]["email"].to_s.downcase.strip
    end
  end

  # Blocklist example: deny requests from bad IPs
  blocklist("bad_ips") do |req|
    [ "1.2.3.4", "5.6.7.8" ].include?(req.ip)
  end

  # Safelist example: allow health checks
  safelist("allow-localhost") do |req|
    "127.0.0.1" == req.ip || "::1" == req.ip
  end
end
