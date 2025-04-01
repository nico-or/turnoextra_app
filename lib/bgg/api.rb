module Bgg
  class Api
    include HTTParty
    base_uri "http://www.boardgamegeek.com/xmlapi"
    format :xml
    parser proc { |body| Nokogiri::XML(body) }

    def search(name)
      response = self.class.get("/search", query: { search: name.downcase })
      return unless response.code == 200
      SearchQuery.new(response).games
    end

    def find_by_id(id)
      response = self.class.get("/boardgame/#{id}")
      return unless response.code == 200
      BoardGameQuery.new(response).games
    end
  end
end
