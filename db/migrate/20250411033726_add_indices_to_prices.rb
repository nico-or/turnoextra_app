class AddIndicesToPrices < ActiveRecord::Migration[8.0]
  def change
    add_index :prices, [ :listing_id, :date ], unique: true
    add_index :prices, :date
    add_index :prices, :amount
  end
end
