class BoardgameDealsService < ApplicationService
  def initialize(reference_date: Price.latest_update_date)
    @reference_date = reference_date
  end

  def call
    Boardgame.joins(listings: [ :prices, :store ])
      .where(prices: { date: @reference_date })
      .having("MIN(prices.amount) < reference_price")
      .group("boardgames.id")
      .select(
        "boardgames.id",
        "boardgames.title AS title",
        "boardgames.image_url AS image_url",
        "boardgames.thumbnail_url AS thumbnail_url",
        "boardgames.reference_price AS reference_price",
        "MIN(prices.amount) AS price")
      .order(discount_string)
  end

  private

  def discount_string
    Arel.sql("( 1.0 * MIN(prices.amount) ) / reference_price")
  end
end
