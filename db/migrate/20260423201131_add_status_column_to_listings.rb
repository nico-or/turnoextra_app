class AddStatusColumnToListings < ActiveRecord::Migration[8.1]
  def up
    add_column :listings, :status, :string, default: "pending", null: false

    # Backfill existing data
    execute <<~SQL
      UPDATE listings SET status =
        CASE
          WHEN boardgame_id IS NOT NULL THEN 'identified'
          WHEN is_boardgame = false THEN 'rejected'
          WHEN id IN (SELECT identifiable_id FROM identification_failures WHERE identifiable_type = 'Listing') THEN 'failed'
          ELSE 'pending'
        END
    SQL
  end

  def down
    remove_column :listings, :status
  end
end
