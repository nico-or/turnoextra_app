module Bgg
  class BoardGame
    def self.from_xml(xml)
      parsed = Nokogiri::XML(xml)

      # valid request, but item not found
      return if parsed.at_xpath("//error")

      new(
        id: parsed.root[:objectid],
        year: parsed.at_xpath("//yearpublished").text,
        name: parsed.at_xpath("//name[@primary]").text,
        names: parsed.xpath("//name").map(&:text),
        description: parsed.at_xpath("//description").text,
        thumbnail_url: parsed.at_xpath("//thumbnail").text,
        image_url: parsed.at_xpath("//image").text,
      )
    end

    attr_reader :id, :year, :name, :names, :description, :thumbnail_url, :image_url

    def initialize(id:, year:, name:, names:, description:, thumbnail_url:, image_url:)
      @id = id
      @year = year
      @name = name
      @names = names
      @description = description
      @thumbnail_url = thumbnail_url
      @image_url = image_url
    end
  end
end
