module Bgg
  BASE_URI = URI.parse("https://boardgamegeek.com")

  class << self
    def uri_for(boardgame)
      URI.join(BASE_URI, "/boardgame/", id_for(boardgame).to_s)
    end

    private

    def id_for(object)
      case object
      when Boardgame then object.bgg_id
      when BoardGame then object.id
      when SearchResult then object.id
      when Integer then object
      when String then object.to_i
      else raise ArgumentError.new("Expected a Boardgame, Bgg::BoardGame, Integer or String, got #{object.class} instead.")
      end
    end
  end
end
