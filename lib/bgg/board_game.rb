module Bgg
  class BoardGame
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
