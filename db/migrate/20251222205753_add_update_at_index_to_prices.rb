class AddUpdateAtIndexToPrices < ActiveRecord::Migration[8.1]
  def change
    add_index :prices, :updated_at
  end
end
