module Bgg::Versions::XmlV2
  module Api
    include HTTParty
    base_uri URI.join(Bgg::BASE_URI, "/xmlapi2").to_s
    format :xml
    parser ->(response, format) { Nokogiri::XML(response) }
    headers "User-Agent" => Bgg::Client::USER_AGENT
    default_params type: [
      ThingType::BOARDGAME,
      ThingType::BOARDGAME_EXPANSION,
      ThingType::RPG_ITEM
    ].join(",")

    class << self
      def search(query)
        params = default_params.merge(query: query)
        response = get("/search", query: params)
        return unless response.code == 200

        response
      end

      def thing(*id, **kwargs)
        params = default_params.merge(id: build_boardgame_query(id))
        params = params.merge(versions: 1) if kwargs[:versions]
        params = params.merge(stats: 1) if kwargs[:stats]
        response = get("/thing", query: params)
        return unless response.code == 200

        response
      end

      private

      def build_boardgame_query(id)
        max_id_count = Bgg::Client::MAX_ID_COUNT_PER_REQUEST
        raise ArgumentError, "Too many IDs provided, maximum is #{max_id_count}. ID: #{id.inspect}." if id.size > max_id_count
        id.join(",")
      end
    end
  end
end
