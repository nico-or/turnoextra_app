class CreateBoardgameDeals < ActiveRecord::Migration[8.1]
  def change
    create_view :boardgame_deals, materialized: true

    # allows concurrent view updates
    add_index :boardgame_deals, :id, unique: true

    # TODO: add index to support pages#home queries
  end
end
