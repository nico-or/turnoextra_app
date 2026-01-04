module Impressions
  class Impressions::ImpressionPolicy
    attr_reader :visitor

    def initialize(visitor)
      @visitor = visitor
    end

    def eligible?
      return false if visitor.admin?
      return false if visitor.bot?
      return false if blacklisted?

      true
    end

    private

    def blacklisted?
      IpBlacklist.include?(visitor.ip_address)
    end
  end
end
