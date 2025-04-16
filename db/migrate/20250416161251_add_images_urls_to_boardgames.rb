class AddImagesUrlsToBoardgames < ActiveRecord::Migration[8.0]
  def change
    add_column :boardgames, :image_url, :string
    add_column :boardgames, :thumbnail_url, :string
  end
end
