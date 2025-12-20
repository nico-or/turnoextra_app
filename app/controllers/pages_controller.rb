class PagesController < ApplicationController
  def home
    case ENV["OLD_HOME"]
    when "1"
      old_home
    else
      new_home
    end
  end

  private

  def old_home
    @last_update_datetime = reference_date
    @deals = top_discounted_deals
    @new_deals = new_price_drops
    @top_bgg = top_ranked_boardgames
    @most_viewed = most_viewed_boardgames
    @top_100_discounted_bgg = top_bgg_games(1, 100)
    @top_1000_discounted_bgg = top_bgg_games(101, 1000)
  end

  def reference_date
    @reference_date ||= Price.latest_update_date&.in_time_zone("America/Santiago")
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
      .select("reference_price - best_price AS net_discount") # TODO: add column to daily_boardgame_deals table
      .where("daily_boardgame_deals.discount > 0")
      .order(
        "net_discount DESC",
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

  def new_base_query
    BoardgameDeal
      .select(
        "id",
        "title",
        "thumbnail_url",
        "rel_discount_100 AS discount",
        "net_discount",
        "t_price AS best_price",
        "m_price AS reference_price",
        "view_count_7d"
      )
      .where.not(t_price: nil) # TODO: add in_stock boolean
      .limit(8)
  end

  def new_home
    @last_update_datetime = reference_date

    @deals = new_base_query
      .where("net_discount > 0")
      .order("net_discount DESC", "is_ranked DESC", "rank")

    @new_deals = new_base_query
      .where(did_drop: true)
      .where("rel_discount_100 > 5")
      .order("discount DESC", "is_ranked DESC", "rank")

    @top_bgg = new_base_query
      .where(is_ranked: true)
      .order("rank")

    @most_viewed = new_base_query
      .where("view_count_7d > 0")
      .order("view_count_7d DESC")

    @top_100_discounted_bgg = new_top_bgg_games(1, 100)

    @top_1000_discounted_bgg = new_top_bgg_games(101, 1000)
  end

  def new_top_bgg_games(min_rank, max_rank)
    new_base_query
      .where("rank BETWEEN ? AND ?", min_rank, max_rank)
      .order("discount DESC", "rank")
  end
end
