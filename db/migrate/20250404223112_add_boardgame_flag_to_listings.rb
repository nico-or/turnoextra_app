class AddBoardgameFlagToListings < ActiveRecord::Migration[8.0]
  def change
    # TODO: consider adding an integer column + enum...
    add_column :listings, :is_boardgame, :boolean, default: true, null: false
  end
end
