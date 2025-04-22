class BoardgameDealsService < ApplicationService
  def initialize(reference_date: Price.latest_update_date)
    @reference_date = reference_date
  end

  def call
    prices_today = Price.where(date: @reference_date)
                        .group(:listing_id)
                        .select ("listing_id, MIN(amount) as amount")

    Boardgame.with(prices_today: prices_today)
      .joins(listings: :store)
      .joins("INNER JOIN prices_today pt ON pt.listing_id = listings.id")
      .where("pt.amount < reference_price")
      .where("ROUND((1 - 1.0 * pt.amount / reference_price) * 100) >= 5")
      .select(
        "boardgames.id",
        "boardgames.title AS title",
        "boardgames.image_url AS image_url",
        "boardgames.thumbnail_url AS thumbnail_url",
        "boardgames.reference_price AS reference_price",
        "pt.amount AS price",
        "ROUND((1 - 1.0 * pt.amount / reference_price) * 100) AS discount_percentage")
      .order("discount_percentage DESC")
      .distinct
  end
end
