class AddIndexToBoardgameBggId < ActiveRecord::Migration[8.0]
  def change
    add_index :boardgames, :bgg_id, unique: true
  end
end
