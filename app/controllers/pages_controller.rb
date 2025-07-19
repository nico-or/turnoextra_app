class PagesController < ApplicationController
  def home
    @last_update_datetime = Price.where(date: reference_date).maximum(:updated_at).in_time_zone("America/Santiago")
    @deals = top_discounted_deals
    @new_deals = new_price_drops
    @top_bgg = top_ranked_boardgames
    @most_viewed = most_viewed_boardgames
    @top_100_discounted_bgg = top_bgg_games(1, 100)
    @top_1000_discounted_bgg = top_bgg_games(101, 1000)
  end

  private

  def reference_date
    @reference_date ||= Price.latest_update_date
  end

  def yesterday_date
    reference_date - 1.day
  end

  def yesterday_prices
    @yesterday_prices ||= Boardgame.joins(:prices)
      .where(prices: { date: yesterday_date })
      .select(
        "boardgames.id AS boardgame_id",
        "MIN(prices.amount) AS amount"
      )
      .group("boardgames.id")
  end

  def base_query
    Boardgame.joins(:daily_boardgame_deals)
      .select(
        "boardgames.id",
        "boardgames.title",
        "boardgames.thumbnail_url",
        "daily_boardgame_deals.discount",
        "daily_boardgame_deals.best_price",
        "daily_boardgame_deals.reference_price"
      )
      .limit(8)
  end

  def top_discounted_deals
    base_query
      .where("daily_boardgame_deals.discount > 0")
      .order(
        "discount DESC",
        Arel.sql("CASE WHEN boardgames.rank = 0 THEN 1 ELSE 0 END ASC"),
        "boardgames.rank ASC"
      )
  end

  def new_price_drops
    base_query
      .with(yesterday_prices: yesterday_prices)
      .joins("JOIN yesterday_prices ON yesterday_prices.boardgame_id = boardgames.id")
      .where("yesterday_prices.amount > daily_boardgame_deals.best_price")
      .order(
        "discount DESC",
        Arel.sql("CASE WHEN boardgames.rank = 0 THEN 1 ELSE 0 END ASC"),
        "boardgames.rank ASC"
      )
  end

  def top_ranked_boardgames
    base_query
      .where("boardgames.rank > 0")
      .order("boardgames.rank ASC")
  end

  def top_bgg_games(min_rank, max_rank)
    base_query
      .where("boardgames.rank BETWEEN ? AND ?", min_rank, max_rank)
      .order(
        "daily_boardgame_deals.discount DESC",
        "boardgames.rank ASC"
      )
  end

  def most_viewed_boardgames
    date_window = (reference_date - 7.days..reference_date)
    base_query
      .joins(:impressions)
      .where(impressions: { date: date_window })
      .group(
        "boardgames.id",
        "boardgames.title",
        "boardgames.thumbnail_url",
        "daily_boardgame_deals.discount",
        "daily_boardgame_deals.best_price",
        "daily_boardgame_deals.reference_price"
      )
      .select("SUM(impressions.count) AS view_count")
      .order("view_count DESC")
  end
end
