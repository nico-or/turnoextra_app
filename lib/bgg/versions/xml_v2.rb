module Bgg::Versions::XmlV2
  class << self
    def search(query)
      response = Api.search(query.downcase)
      return unless response
      SearchResponseParser.parse!(response)
    end

    def boardgame(*id)
      response = Api.thing(id)
      return unless response
      ThingResponseParser.parse!(response)
    end
  end
end
