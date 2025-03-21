module Bgg
  class SearchById < ApplicationService
    def initialize(id)
      @id = id
    end

    def call
      api = Bgg::Api.new
      api.find_by_id(@id)
    end
  end
end
