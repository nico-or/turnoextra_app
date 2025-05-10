class BoardgameDealsService < ApplicationService
  def call
    Boardgame.where(
      "best_price IS NOT NULL",
      "best_price < reference_price")
      .order("discount DESC", "rank ASC")
  end
end
