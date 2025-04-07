class RenamePricePriceColumn < ActiveRecord::Migration[8.0]
  def change
    rename_column :prices, :price, :amount
  end
end
