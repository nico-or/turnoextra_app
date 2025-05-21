class CreateDailyBoardgameDeals < ActiveRecord::Migration[8.0]
  def change
    create_table :daily_boardgame_deals do |t|
      t.references :boardgame, null: false, foreign_key: true
      t.integer :best_price, default: 0, null: false
      t.integer :reference_price, default: 0, null: false
      t.integer :discount, default: 0, null: false
      t.date :date, null: false, index: true

      t.timestamps

      t.index [ :boardgame_id, :date ], unique: true
    end

    # Remove columns from Boardgame model that are no longer needed
    remove_column :boardgames, :best_price, :integer, default: 0, null: false
    remove_column :boardgames, :reference_price, :integer, default: 0, null: false
    remove_column :boardgames, :discount, :integer, default: 0, null: false
  end
end
