class CreateStoreSuggestions < ActiveRecord::Migration[8.0]
  def change
    create_table :store_suggestions do |t|
      t.string :url, null: false
      t.integer :count, default: 0, null: false

      t.timestamps
    end
  end
end
