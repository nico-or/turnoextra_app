class AddPlayerCountsToBoardgames < ActiveRecord::Migration[8.0]
  def change
    add_column :boardgames, :min_players, :integer
    add_column :boardgames, :max_players, :integer
  end
end
