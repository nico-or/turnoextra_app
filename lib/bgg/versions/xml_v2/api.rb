module Bgg::Versions::XmlV2
  module Api
    include HTTParty
    base_uri URI.join(Bgg::BASE_URI, "/xmlapi2").to_s
    format :xml
    parser ->(response, format) { Nokogiri::XML(response) }
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

      def thing(*id, versions: false, stats: false)
        params = default_params.merge(id: build_boardgame_query(id))
        params = params.merge(versions: 1) if versions
        params = params.merge(stats: 1) if stats
        response = get("/thing", query: params)
        return unless response.code == 200

        response
      end

      private

      def build_boardgame_query(id)
        raise ArgumentError, "Too many IDs provided, maximum is 20. ID: #{id.inspect}." if id.size > 20
        id.join(",")
      end
    end
  end
end
