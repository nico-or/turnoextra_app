module Bgg
  class Client
    TTL = 6.hours
    DEFAULT_VERSION = :xml_v2
    MAX_ID_COUNT_PER_REQUEST = 20 # This should be a version/*/api specific constant, but for now it's global.

    def initialize(version = DEFAULT_VERSION)
      @client = case version
      when :xml_v1 then Bgg::Versions::XmlV1::Client.new
      when :xml_v2 then Bgg::Versions::XmlV2::Client.new
      else raise ArgumentError, "Unsupported version: #{version}"
      end
    end

    def search(query)
      normalized_query = StringNormalizationService.normalize_string(query)
      cache_key = build_cache_key(:search, normalized_query)
      Rails.cache.fetch(cache_key, expires_in: TTL) do
        @client.search(normalized_query) || []
      end
    end

    def boardgame(*id)
      cache_key = build_cache_key(:boardgame, *id)
      Rails.cache.fetch(cache_key, expires_in: TTL) do
        @client.boardgame(*id) || []
      end
    end

    private

    def build_cache_key(action, *args)
      api_version_string = @client.class.to_s.parameterize
      args_string = args.map(&:to_s).join("_")
      "#{api_version_string}/#{action}/#{args_string}"
    end
  end
end
