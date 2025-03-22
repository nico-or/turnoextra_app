class CreateListings < ActiveRecord::Migration[8.0]
  def change
    create_table :listings do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
