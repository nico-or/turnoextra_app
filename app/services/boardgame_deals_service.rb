class BoardgameDealsService < ApplicationService
  def initialize(reference_date: Price.latest_update_date, window_size: 2.weeks)
    @reference_date = reference_date
    @window_size = window_size
  end

  def call
    prices_today = Price.where(date: @reference_date)
                        .group(:listing_id)
                        .select ("listing_id, MIN(amount) as amount")

    prices_week = Price.where(date: date_range)
                       .group(:listing_id)
                       .select ("listing_id, CAST(AVG(amount) AS INT) as amount")

    Boardgame.with(prices_today: prices_today, prices_week: prices_week)
      .joins(listings: :store)
      .joins("INNER JOIN prices_today pt ON pt.listing_id = listings.id")
      .joins("INNER JOIN prices_week pw ON pw.listing_id = listings.id")
      .where("pt.amount < pw.amount")
      .select(
        "boardgames.id",
        "boardgames.title AS title",
        "boardgames.image_url AS image_url",
        "boardgames.thumbnail_url AS thumbnail_url",
        "stores.name AS store_name",
        "pt.amount AS price",
        "ROUND((1.0 * pw.amount / pt.amount - 1) * 100) AS discount_percentage")
      .order("discount_percentage DESC")
  end

  private

  def date_range
    (@reference_date - @window_size)..(@reference_date - 1.day)
  end
end
