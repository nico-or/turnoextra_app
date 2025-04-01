module Bgg
  class SearchByName < ApplicationService
    def initialize(name)
      @name = name
    end

    def call
      identifier = Bgg::Identifier.new
      identifier.identify!(@name)
    end
  end
end
