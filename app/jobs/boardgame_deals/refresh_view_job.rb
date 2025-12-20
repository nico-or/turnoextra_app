module BoardgameDeals
  class RefreshViewJob < ApplicationJob
    queue_as :default

    def perform(*args)
      BoardgameDeal.refresh
    end
  end
end
