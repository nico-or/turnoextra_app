class AddFailedIdentificationToListings < ActiveRecord::Migration[8.0]
  def change
    add_column :listings, :failed_identification, :boolean, default: false
  end
end
