module Bgg
  class SearchQuery
    def initialize(response)
      @response = response
    end

    def games
      boardgame_nodes.map { |node| parse_node(node) }.compact
    end

    private

    def boardgame_nodes
      @response.xpath("//boardgame")
    end

    def parse_node(node)
      SearchResult.new(
        id: node[:objectid],
        name: node.at_xpath("name")&.text,
        year: node.at_xpath("yearpublished")&.text
      )
    end
  end
end
