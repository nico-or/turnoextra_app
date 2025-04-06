module Bgg
  class Api
    include HTTParty
    base_uri "https://www.boardgamegeek.com/xmlapi"
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
      BoardGameQuery.new(response).games
    end
  end
end
