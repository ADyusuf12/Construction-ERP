module Earmark
  class Config
    def self.client_name
      ENV["CLIENT_NAME"] || "Hamzis Construction" # Default to Hamzis for now
    end

    def self.primary_color
      ENV["PRIMARY_COLOR"] || "#f97316" # Hamzis Orange hex
    end
  end
end
