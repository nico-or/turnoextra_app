class CreateContactMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_messages do |t|
      t.string :name
      t.string :email
      t.text :body
      t.string :user_agent, null: false

      t.integer :subject, default: 0, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
