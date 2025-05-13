class BoardgameDealsService < ApplicationService
  def call
    Boardgame.where(
      "best_price < reference_price",
      "discount > 5")
      .order("discount DESC", "rank ASC")
  end
end
