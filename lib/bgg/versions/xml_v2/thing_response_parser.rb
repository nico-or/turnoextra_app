module Bgg::Versions::XmlV2::ThingResponseParser
  class << self
    def parse!(response)
      thing_nodes(response).map { |node| build_thing(node) }.compact
    end

    private

    def thing_nodes(response)
      response.xpath("/items/item")
    end

    def build_thing(node)
      Bgg::BoardGame.new(
        id: node[:id].to_i,
        year: node.at_xpath("yearpublished")&.attr(:value)&.to_i,
        name: node.at_xpath("name[@type='primary']")&.attr(:value),
        names: node.xpath("name").map { it[:value] },
        description: node.at_xpath("description")&.text&.strip,
        thumbnail_url: node.at_xpath("thumbnail")&.text&.strip,
        image_url: node.at_xpath("image")&.text&.strip
      )
    end
  end
end
