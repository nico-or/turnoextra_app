class AddIndicesToTitleColumns < ActiveRecord::Migration[8.0]
  def change
    add_index :boardgames, :title
    add_index :listings, :title
  end
end
