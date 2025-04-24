class AddYearToBoardgames < ActiveRecord::Migration[8.0]
  def change
    add_column :boardgames, :year, :integer, null: false, default: 0
  end
end
