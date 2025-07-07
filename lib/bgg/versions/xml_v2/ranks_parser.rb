module Bgg::Versions::XmlV2::RanksParser
  class << self
    def parse(response)
      rank_nodes(response).map { |node| parse_rank(node) }.compact
    end

    private

    def rank_nodes(response)
      response.xpath("//rank")
    end

    def parse_rank(node)
      Bgg::Rank.new(
        type: node&.attr("type"),
        id: node&.attr("id")&.to_i,
        name: node&.attr("name"),
        friendlyname: node&.attr("friendlyname"),
        value: node&.attr("value")&.to_f,
        bayesaverage: node&.attr("bayesaverage")&.to_f,
      )
    end
  end
end
