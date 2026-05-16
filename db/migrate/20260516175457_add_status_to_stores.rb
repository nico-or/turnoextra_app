class AddStatusToStores < ActiveRecord::Migration[8.1]
  def change
    add_column :stores, :status, :string, default: 'pending'
  end
end
