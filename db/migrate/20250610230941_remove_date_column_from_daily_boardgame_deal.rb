class RemoveDateColumnFromDailyBoardgameDeal < ActiveRecord::Migration[8.0]
  def change
    remove_index :daily_boardgame_deals, :date
    remove_index :daily_boardgame_deals, [ :boardgame_id, :date ], unique: true

    remove_column :daily_boardgame_deals, :date, :date
  end
end
