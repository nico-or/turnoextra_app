module Bgg
  class SearchByName < ApplicationService
    def initialize(name)
      @name = name
    end

    def call
      api = Bgg::Api.new
      api.search(@name)
    end
  end
end
