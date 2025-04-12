module Bgg::Versions::XmlV1::BoardgameResponseParser
  class << self
    def parse!(response)
      boardgame_nodes(response).map { |node| parse_node(node) }.compact
    end

    private

    def boardgame_nodes(response)
      # Queries with no results still return a single <boardgame> tag
      # with an <error> child inside, so we filter those out.
      response.xpath("//boardgame").reject { |node| node.at_xpath("error") }
    end

    def parse_node(node)
      Bgg::BoardGame.new(
        id: node[:objectid].to_i,
        year: node.at_xpath("yearpublished")&.text.to_i,
        name: node.at_xpath("name[@primary]")&.text,
        names: node.xpath("name").map(&:text),
        description: node.at_xpath("description")&.text,
        thumbnail_url: node.at_xpath("thumbnail")&.text,
        image_url: node.at_xpath("image")&.text
      )
    end
  end
end
