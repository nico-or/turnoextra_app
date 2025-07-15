class AddPlaytimesToBoardgames < ActiveRecord::Migration[8.0]
  def change
    add_column :boardgames, :min_playtime, :integer
    add_column :boardgames, :max_playtime, :integer
  end
end
