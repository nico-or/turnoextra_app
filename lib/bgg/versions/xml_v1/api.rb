module Bgg::Versions::XmlV1::Api
  include HTTParty
  base_uri URI.join(Bgg::BASE_URI, "/xmlapi").to_s
  format :xml
  parser ->(response, format) { Nokogiri::XML(response) }

  class << self
    def search(query)
      response = get("/search", query: { search: query })
      return unless response.code == 200

      response
    end

    def boardgame(*id)
      query = build_boardgame_query(id)
      response = get("/boardgame/#{query}")
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
