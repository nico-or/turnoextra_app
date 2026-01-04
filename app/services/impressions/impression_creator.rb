module Impressions
  class ImpressionCreator
    attr_reader :trackable, :visitor

    def initialize(trackable, visitor:)
      @trackable = trackable
      @visitor = visitor
    end

    def create
      return unless eligible?

      create_impression
    end

    private

    def eligible?
      ImpressionPolicy.new(visitor).eligible?
    end

    def create_impression
      impression = Impression.find_or_create_by(trackable: trackable, date: Date.current)
      Impression.increment_counter(:count, impression.id)
    end
  end
end
