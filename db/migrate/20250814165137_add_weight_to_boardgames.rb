class AddWeightToBoardgames < ActiveRecord::Migration[8.0]
  def change
    add_column :boardgames, :weight, :float
  end
end
