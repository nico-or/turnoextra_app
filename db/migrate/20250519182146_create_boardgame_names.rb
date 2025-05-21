class CreateBoardgameNames < ActiveRecord::Migration[8.0]
  def change
    create_table :boardgame_names do |t|
      t.references :boardgame, null: false, foreign_key: true
      t.string :value, null: false
      t.boolean :preferred, null: false, default: false

      t.timestamps

      t.index [ :boardgame_id, :value ], unique: true
    end
  end
end
