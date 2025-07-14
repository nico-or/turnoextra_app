class CreateThingsLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :things_links do |t|
      t.references :boardgame, null: false, foreign_key: true
      t.string :link_type
      t.integer :link_id
      t.string :value

      t.timestamps
    end
  end
end
