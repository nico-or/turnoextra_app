class AddNormalizedTitleToBoardgamesAndListings < ActiveRecord::Migration[8.0]
  def change
    add_column :boardgames, :normalized_title, :string
    add_column :listings, :normalized_title, :string
  end
end
