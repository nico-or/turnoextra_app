class PagesController < ApplicationController
  skip_before_action :authorize_user

  def home
    # OPTIMIZE: Consider Rails.cache.fetch("homepage_week_deals", expires_in: 1.hour) in production
    @week_deals = deals_for_range(Date.today, 14).limit(12).to_a
  end

  private

  # TODO: add tests for this method
  def deals_for_range(date, window_size)
    range = (date-window_size)..(date-1)

    prices_today = Price
      .where(date: date)
      .group(:listing_id)
      .select("listing_id, MIN(amount) as amount")

    prices_week = Price
      .where(date: range)
      .group(:listing_id)
      .select("listing_id, CAST(AVG(amount) AS INT) as amount")

    Boardgame
      .with(
        prices_today: prices_today,
        prices_week: prices_week
      )
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
        "pt.amount AS lpt",
        "pw.amount AS lpw",
        "CAST((pw.amount - pt.amount) AS INT) AS net_discount",
        "ROUND((1.0 * pw.amount / pt.amount - 1) * 100) AS perc_discount"
      )
      .order("perc_discount DESC")
  end
end
