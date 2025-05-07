module Bgg
  class Client
    def initialize(version = :xml_v1)
      @client = case version
      when :xml_v1 then Bgg::Versions::XmlV1::Client.new
      when :xml_v2 then Bgg::Versions::XmlV2::Client.new
      else raise ArgumentError, "Unsupported version: #{version}"
      end
    end

    def search(query)
      @client.search(query)
    end

    def boardgame(*id)
      @client.boardgame(*id)
    end
  end
end
