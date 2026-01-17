class RenameContactMessagesStateColumns < ActiveRecord::Migration[8.1]
  def change
    add_column :contact_messages, :archived_status, :integer, default: 0, null: false
    add_column :contact_messages,     :read_status, :integer, default: 0, null: false
    add_column :contact_messages,     :spam_status, :integer, default: 0, null: false

    remove_column :contact_messages, :archived, :bool, default: false, null: false
    remove_column :contact_messages,     :read, :bool, default: false, null: false
    remove_column :contact_messages,     :spam, :bool, default: false, null: false
  end
end
