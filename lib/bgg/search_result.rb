module Bgg
  class SearchResult
    attr_reader :name, :year, :id

    def initialize(name:, year:, id:)
      @name = name
      @year = year
      @id = id
    end
  end
end
