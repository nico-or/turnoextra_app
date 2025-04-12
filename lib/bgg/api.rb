module Bgg
  class Api
    include HTTParty
    base_uri URI.join(BASE_URI, "/xmlapi").to_s
    format :xml
    parser proc { |body| Nokogiri::XML(body) }

    def search(query)
      response = self.class.get("/search", query: { search: query })
      return unless response.code == 200
      SearchResponseParser.new(response).games
    end

    def find_by_id(id)
      response = self.class.get("/boardgame/#{id}")
      return unless response.code == 200
      BoardgameResponseParser.new(response).games
    end
  end
end
