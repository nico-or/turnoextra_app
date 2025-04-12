module Bgg::Versions::XmlV1::SearchResponseParser
  class << self
    def parse!(response)
      boardgame_nodes(response).map { |node| parse_node(node) }.compact
    end

    private

    def boardgame_nodes(response)
      response.xpath("//boardgame")
    end

    def parse_node(node)
      Bgg::SearchResult.new(
        id: node[:objectid].to_i,
        name: node.at_xpath("name")&.text,
        year: node.at_xpath("yearpublished")&.text&.to_i
      )
    end
  end
end
