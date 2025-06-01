class RemoveFailedIdentificationColumnsFromListings < ActiveRecord::Migration[8.0]
  def change
    remove_column :listings, :failed_local_identification, :boolean, default: false
    remove_column :listings, :failed_bgg_api_identification, :boolean, default: false
  end
end
