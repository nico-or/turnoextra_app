class DealsController < ApplicationController
  def index
    boardgames = BoardgameDeal
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

    @pagy, @boardgames = pagy(boardgames)
  end
end
