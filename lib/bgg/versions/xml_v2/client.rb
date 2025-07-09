module Bgg::Versions::XmlV2
  class Client
    def search(query)
      response = Api.search(query.downcase)
      return unless response
      SearchResponseParser.parse!(response)
    end

    def boardgame(*id, **kwargs)
      response = Api.thing(*id, **kwargs)
      return unless response
      ThingResponseParser.parse!(response)
    end
  end
end
