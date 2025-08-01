module Bgg
  class Client
    TTL = 6.hours
    DEFAULT_VERSION = :xml_v2
    USER_AGENT = "TurnoExtraApp/1.0 (+https://turnoextra.cl/contact) Ruby/#{RUBY_VERSION} HTTParty/#{HTTParty::VERSION}"
    MAX_ID_COUNT_PER_REQUEST = 20 # This should be a version/*/api specific constant, but for now it's global.

    def initialize(version = DEFAULT_VERSION)
      @client = case version
      when :xml_v2 then Bgg::Versions::XmlV2::Client.new
      else raise ArgumentError, "Unsupported version: #{version}"
      end
    end

    def search(query)
      normalized_query = Text::Normalization.normalize_string(query)
      cache_key = build_cache_key(:search, normalized_query)
      Rails.cache.fetch(cache_key, expires_in: TTL) do
        @client.search(normalized_query) || []
      end
    end

    def boardgame(*id, **kwargs)
      cache_key = build_cache_key(:boardgame, *id, **kwargs)
      Rails.cache.fetch(cache_key, expires_in: TTL) do
        @client.boardgame(*id, **kwargs) || []
      end
    end

    private

    def build_cache_key(action, *args, **kwargs)
      action_string = action.to_s
      api_version_string = @client.class.to_s.parameterize
      args_string = args.map(&:to_s).join("_") if args.any?
      kwargs_string = kwargs.map { |k, v| "#{k}=#{v}" }.join("&") if kwargs.any?
      "#{api_version_string}/#{action_string}/#{args_string}/#{kwargs_string}"
    end
  end
end
