class AddUniqueIndexToListingsUrl < ActiveRecord::Migration[8.0]
  def change
    add_index :listings, :url, unique: true
  end
end
