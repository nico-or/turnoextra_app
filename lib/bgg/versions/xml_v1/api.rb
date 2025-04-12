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
      raise ArgumentError, "Too many IDs provided, maximum is 20. ID: #{id.inspect}." if id.size > 20
      id.join(",")
    end
  end
end
