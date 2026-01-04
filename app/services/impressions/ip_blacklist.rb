module Impressions
  module IpBlacklist
    RANGES = [
      "74.125.151.0/24" # google, but uses a real user agent
    ].freeze

    def self.include?(ip)
      RANGES.any? { |range| IPAddr.new(range).include?(ip) }
    end
  end
end
