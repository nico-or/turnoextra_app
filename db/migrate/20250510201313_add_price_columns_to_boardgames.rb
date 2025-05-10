class AddPriceColumnsToBoardgames < ActiveRecord::Migration[8.0]
  def change
    add_column :boardgames, :best_price, :integer
    add_column :boardgames, :discount, :integer

    reversible do |dir|
      dir.up { change_column :boardgames, :reference_price, :integer }
      dir.down { change_column :boardgames, :reference_price, :integer, null: false, default: 0 }
    end
  end
end
