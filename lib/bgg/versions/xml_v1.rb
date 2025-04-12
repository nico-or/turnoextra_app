module Bgg::Versions::XmlV1
  class << self
    def search(query)
      response = Api.search(query.downcase)
      return unless response
      SearchResponseParser.parse!(response)
    end

    def boardgame(*id)
      response = Api.boardgame(id)
      return unless response
      BoardgameResponseParser.parse!(response)
    end
  end
end
