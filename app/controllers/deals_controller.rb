class DealsController < ApplicationController
  def index
    boardgames = Boardgame.joins(:daily_boardgame_deals)
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

    @pagy, @boardgames = pagy(boardgames)
  end
end
