class DealsController < ApplicationController
  def index
    boardgames = case ENV["OLD_HOME"]
    when "1"
      Boardgame.joins(:daily_boardgame_deals)
        .select(
          "boardgames.id",
          "boardgames.title",
          "boardgames.thumbnail_url",
          "daily_boardgame_deals.discount",
          "daily_boardgame_deals.best_price",
          "daily_boardgame_deals.reference_price")
        .where("daily_boardgame_deals.discount > 0")
        .order("discount DESC",  "title ASC")
        .distinct
    else
      BoardgameDeal
        .select(
          "id",
          "title",
          "thumbnail_url",
          "t_price AS best_price",
          "m_price AS reference_price",
          "rel_discount_100 AS discount",
        )
        .where("t_price > 0")
        .where("rel_discount_100 > 0")
        .order("discount DESC", "title")
    end

    @pagy, @boardgames = pagy(boardgames)
  end
end
