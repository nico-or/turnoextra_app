class DropDailyBoardgameDealsTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :daily_boardgame_deals do |t|
      t.references :boardgame, null: false, foreign_key: true
      t.integer :best_price, default: 0, null: false
      t.integer :reference_price, default: 0, null: false
      t.integer :discount, default: 0, null: false
      t.date :date, null: false, index: true

      t.timestamps

      t.index [ :boardgame_id, :date ], unique: true
    end
  end
end
