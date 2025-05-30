class CreateImpressions < ActiveRecord::Migration[8.0]
  def change
    create_table :impressions do |t|
      t.references :trackable, polymorphic: true, null: false
      t.date :date
      t.integer :count

      t.timestamps
    end

    add_index :impressions, [ :trackable_id, :trackable_type, :date ], unique: true
  end
end
