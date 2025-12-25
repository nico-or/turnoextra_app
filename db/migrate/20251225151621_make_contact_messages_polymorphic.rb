class MakeContactMessagesPolymorphic < ActiveRecord::Migration[8.1]
  class MigrationContactMessage < ActiveRecord::Base
    self.table_name = "contact_messages"
  end

  def up
    add_reference :contact_messages, :contactable, polymorphic: true, index: true

    regex = /boardgame_id: (\d+)/

    MigrationContactMessage.find_each do |msg|
      match = msg.body&.match(regex)
      next unless match

      msg.update_columns(
        contactable_id: match[1],
        contactable_type: "Boardgame"
      )
    end
  end

  def down
    remove_reference :contact_messages, :contactable, polymorphic: true
  end
end
