class CreatePrices < ActiveRecord::Migration[8.0]
  def change
    create_table :prices do |t|
      t.integer :price, null: false
      t.date :date, null: false
      t.references :listing, null: false, foreign_key: true

      t.timestamps
    end
  end
end
