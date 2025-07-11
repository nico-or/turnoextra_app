module Bgg::Versions::XmlV2
  module LinksParser
    class << self
      def parse(response)
        link_nodes(response).map { |node| parse_link(node) }.compact
      end

      private

      def link_nodes(response)
        response.xpath("link")
      end

      def parse_link(node)
        Bgg::Link.new(
          type: node&.attr("type"),
          id: node&.attr("id")&.to_i,
          value: node&.attr("value"),
        )
      end
    end
  end
end
