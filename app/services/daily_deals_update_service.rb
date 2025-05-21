class DailyDealsUpdateService < ApplicationService
  def call
    daily_boardgame_deals = BoardgameDealsService.new.call
    params = daily_boardgame_deals.map do |boardgame|
      {
        boardgame_id: boardgame.id,
        date: boardgame.date,
        best_price: boardgame.best_price,
        reference_price: boardgame.reference_price,
        discount: boardgame.discount
      }
    end

    DailyBoardgameDeal.upsert_all(params, unique_by: [ :boardgame_id, :date ])
  end
end
