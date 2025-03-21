module Bgg
  class SearchResult
    def self.from_xml(xml)
      parsed = Nokogiri::XML(xml)
      new(
        name: parsed.xpath("//name").text,
        year: parsed.xpath("//yearpublished").text,
        id: parsed.root[:objectid]
      )
    end

    attr_reader :name, :year, :id

    def initialize(name:, year:, id:)
      @name = name
      @year = year
      @id = id
    end
  end
end
