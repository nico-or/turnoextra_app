class CreateIdentificationFailures < ActiveRecord::Migration[8.0]
  def change
    create_table :identification_failures do |t|
      t.references :identifiable, polymorphic: true, null: false
      t.string :search_method, null: false
      t.string :reason

      t.timestamps
    end

    add_index :identification_failures, [ :identifiable_type, :identifiable_id, :search_method ], unique: true
  end
end
