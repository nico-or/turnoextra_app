module Bgg::Versions::XmlV2::SearchResponseParser
  class << self
    def parse!(response)
      boardgame_nodes(response).map { |node| parse_node(node) }.compact
    end

    private

    def boardgame_nodes(response)
      response.xpath("//item")
    end

    def parse_node(node)
      Bgg::SearchResult.new(
        id: node[:id].to_i,
        name: node.at_xpath("name").attr(:value),
        year: node.at_xpath("yearpublished")&.attr(:value)&.to_i
      )
    end
  end
end
