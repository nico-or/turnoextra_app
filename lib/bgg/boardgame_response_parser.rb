module Bgg
  class BoardgameResponseParser
    def initialize(response)
      @response = response
    end

    def games
      boardgame_nodes.map { |node| parse_node(node) }.compact
    end

    private

    def boardgame_nodes
      # Queries with no results still return a single <boardgame> tag
      # with an <error> child inside, so we filter those out.
      @response.xpath("//boardgame").reject { |node| node.at_xpath("error") }
    end

    def parse_node(node)
      BoardGame.new(
        id: node[:objectid],
        year: node.at_xpath("yearpublished")&.text,
        name: node.at_xpath("name[@primary]")&.text,
        names: node.xpath("name").map(&:text),
        description: node.at_xpath("description")&.text,
        thumbnail_url: node.at_xpath("thumbnail")&.text,
        image_url: node.at_xpath("image")&.text
      )
    end
  end
end
