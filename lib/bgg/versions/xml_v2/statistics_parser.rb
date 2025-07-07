module Bgg::Versions::XmlV2::StatisticsParser
  class << self
    def parse(statistics_node)
      ratings_node = statistics_node.at_xpath("ratings")
      return unless ratings_node

      Bgg::Statistics.new(
        ranks: ranks(ratings_node),
        **extract_fields(ratings_node, int_fields, :to_i),
        **extract_fields(ratings_node, float_fields, :to_f)
      )
    end

    private

    def ranks(ratings_node)
      ranks_node = ratings_node.at_xpath("ranks")
      Bgg::Versions::XmlV2::RanksParser.parse(ranks_node)
    end

    def int_fields
      %w[usersrated median owned trading wanting wishing numcomments numweights]
    end

    def float_fields
      %w[average bayesaverage stddev averageweight]
    end

    def extract_fields(node, fields, conversion = :itself)
      fields.each_with_object({}) do |field, hash|
        hash[field.to_sym] = node.at_xpath(field)&.attr("value")&.send(conversion)
      end
    end
  end
end
