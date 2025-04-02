class AddRankToBoardgames < ActiveRecord::Migration[8.0]
  def change
    # BGG uses rank = 0 for boardgames without rank
    add_column :boardgames, :rank, :integer, null: false, default: 0
  end
end
