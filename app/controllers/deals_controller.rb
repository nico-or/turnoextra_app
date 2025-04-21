class DealsController < ApplicationController
  skip_before_action :authorize_user, only: %i[index]

  def index
    # OPTIMIZE: Consider Rails.cache.fetch("homepage_week_deals", expires_in: 1.hour) in production
    @reference_date = Price.latest_update_date
    @boardgames = BoardgameDealsService.new(reference_date: @reference_date).call
    @pagy, @boardgames = pagy(@boardgames)
  end
end
