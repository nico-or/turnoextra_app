class AddEnumColumnsToContactMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :contact_messages, :archived, :bool, default: false, null: false
    add_column :contact_messages,     :read, :bool, default: false, null: false
    add_column :contact_messages,     :spam, :bool, default: false, null: false
  end
end
