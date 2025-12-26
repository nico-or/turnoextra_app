class PagesController < ApplicationController
  def home
    @last_update_datetime = last_update_datetime

    @deals = new_base_query
      .where("net_discount > 0")
      .order("net_discount DESC", "is_ranked DESC", "rank")

    @new_deals = new_base_query
      .where(did_drop: true)
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

  private

  def last_update_datetime
    Price.maximum(:updated_at).in_time_zone("America/Santiago")
  end

  def new_base_query
    BoardgameDeal
      .with_boardgame_card_data
      .limit(8)
  end

  def new_top_bgg_games(min_rank, max_rank)
    new_base_query
      .where("rank BETWEEN ? AND ?", min_rank, max_rank)
      .where("rel_discount_100 > 0")
      .order("discount DESC", "rank")
  end
end
