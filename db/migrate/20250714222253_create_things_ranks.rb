class CreateThingsRanks < ActiveRecord::Migration[8.0]
  def change
    create_table :things_ranks do |t|
      t.references :boardgame, null: false, foreign_key: true
      t.string :rank_type
      t.integer :rank_id
      t.string :name
      t.string :friendlyname
      t.integer :value
      t.float :bayesaverage

      t.timestamps
    end
  end
end
