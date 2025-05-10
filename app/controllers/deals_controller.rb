class DealsController < ApplicationController
  def index
    # OPTIMIZE: Consider Rails.cache.fetch("homepage_week_deals", expires_in: 1.hour) in production
    @reference_date = Price.latest_update_date
    @boardgames = BoardgameDealsService.call
    @pagy, @boardgames = pagy(@boardgames)
  end
end
