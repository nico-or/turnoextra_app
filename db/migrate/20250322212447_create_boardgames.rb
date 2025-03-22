class CreateBoardgames < ActiveRecord::Migration[8.0]
  def change
    create_table :boardgames do |t|
      t.string :title
      t.integer :bgg_id

      t.timestamps
    end

    change_table :listings do |t|
      t.references :boardgame
    end
  end
end
