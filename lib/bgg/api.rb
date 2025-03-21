module Bgg
  class Api
    include HTTParty
    base_uri "http://www.boardgamegeek.com/xmlapi"
    format :xml
    parser NokogiriParser

    def search(name)
      response = self.class.get("/search", query: { search: name.downcase })
      return unless response.code == 200
      boardgames(response)
    end

    def find_by_id(id)
      response = self.class.get("/boardgame/#{id}")
      return unless response.code == 200
      data = response.xpath("/boardgames/boardgame") || []
      return if data.empty?

      BoardGame.from_xml(data.first.to_xml)
    end

    private

    def boardgames(response)
      data = response.xpath("/boardgames/boardgame") || []
      data.map { SearchResult.from_xml(it.to_xml) }
    end
  end
end
