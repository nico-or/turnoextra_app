module Bgg::Versions::XmlV2
  module ThingResponseParser
    class << self
      def parse!(response)
        thing_nodes(response).map { |node| build_thing(node) }.compact
      end

      private

      def thing_nodes(response)
        response.xpath("/items/item")
      end

      def statistics(thing_node)
        statistics_node = thing_node.at_xpath("statistics")
        return unless statistics_node

        StatisticsParser.parse(statistics_node)
      end

      def build_thing(node)
        Bgg::Boardgame.new(
          bgg_id: node[:id].to_i,
          year: node.at_xpath("yearpublished")&.attr(:value)&.to_i,
          title: node.at_xpath("name[@type='primary']")&.attr(:value),
          titles: node.xpath("name").map { it[:value] },
          description: node.at_xpath("description")&.text&.strip,
          thumbnail_url: node.at_xpath("thumbnail")&.text&.strip,
          image_url: node.at_xpath("image")&.text&.strip,
          min_players: node.at_xpath("minplayers")&.attr(:value)&.to_i,
          max_players: node.at_xpath("maxplayers")&.attr(:value)&.to_i,
          min_playtime: node.at_xpath("minplaytime")&.attr(:value)&.to_i,
          max_playtime: node.at_xpath("maxplaytime")&.attr(:value)&.to_i,
          playingtime: node.at_xpath("playingtime")&.attr(:value)&.to_i,
          statistics: statistics(node),
          links: LinksParser.parse(node),
        )
      end
    end
  end
end
