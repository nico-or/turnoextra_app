class DailyDealsUpdateService < ApplicationService
  def call
    daily_boardgame_deals = BoardgameDealsService.call
    params = daily_boardgame_deals.map do |boardgame|
      {
        boardgame_id: boardgame.id,
        best_price: boardgame.best_price,
        reference_price: boardgame.reference_price,
        discount: boardgame.discount
      }
    end

    DailyBoardgameDeal.destroy_all
    DailyBoardgameDeal.insert_all(params)
  end
end
