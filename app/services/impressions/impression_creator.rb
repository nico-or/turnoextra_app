module Impressions
  class ImpressionCreator
    attr_reader :trackable, :visitor

    def initialize(trackable, visitor:)
      @trackable = trackable
      @visitor = visitor
    end

    def create
      return unless worthy?

      create_impression
    end

    private

    def worthy?
      VisitorValidator.new(visitor).worthy?
    end

    def create_impression
      impression = Impression.find_or_create_by(trackable: trackable, date: Date.current)
      Impression.increment_counter(:count, impression.id)
    end
  end
end
