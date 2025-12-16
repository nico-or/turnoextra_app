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

          thumbnail_url:  parse_str_attribute(node, "thumbnail"),
          image_url:      parse_str_attribute(node, "image"),

          title:  node.at_xpath("name[@type='primary']")&.attr(:value),
          titles: node.xpath("name").map { it[:value] },

          description:  parse_str_attribute(node, "description"),

          year:         parse_int_attribute(node,"yearpublished"),
          min_players:  parse_int_attribute(node, "minplayers"),
          max_players:  parse_int_attribute(node, "maxplayers"),
          
          # poll: suggested_numplayers
          # poll-summary: suggested_numplayer
          
          playingtime:  parse_int_attribute(node, "playingtime"),
          min_playtime: parse_int_attribute(node, "minplaytime"),
          max_playtime: parse_int_attribute(node, "maxplaytime"),
          min_age:      parse_int_attribute(node, "minage"),
          
          # poll: suggested_playerage
          # poll: language_dependence
          
          links: LinksParser.parse(node),
          # versions: Array[Bgg::Version]
          statistics: statistics(node),
        )
      end

      def parse_str_attribute(node,selector)
        node.at_xpath(selector)&.text&.strip
      end

      def parse_int_attribute(node, selector)
        node.at_xpath(selector)&.attr(:value)&.to_i
      end
    end
  end
end
