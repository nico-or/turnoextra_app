class AddReferencePriceToBoardgames < ActiveRecord::Migration[8.0]
  def change
    add_column :boardgames, :reference_price, :integer, default: 0, null: false
  end
end
