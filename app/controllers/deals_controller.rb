class DealsController < ApplicationController
  def index
    boardgames = BoardgameDeal
      .with_boardgame_card_data
      .where("rel_discount_100 > 0")
      .order("discount DESC", "title")

    @pagy, @boardgames = pagy(boardgames)
  end
end
