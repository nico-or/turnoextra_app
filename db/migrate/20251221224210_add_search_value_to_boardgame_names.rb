class AddSearchValueToBoardgameNames < ActiveRecord::Migration[8.1]
  def change
    add_column :boardgame_names, :search_value, :string

    # Remove previous index
    remove_index :boardgame_names, :value,
      using: :gin,
      opclass: :gin_trgm_ops,
      name: "index_boardgame_names_on_value_trgm"

    # Standard trigram index on the new column
    add_index :boardgame_names, :search_value,
      using: :gin,
      opclass: :gin_trgm_ops,
      name: "index_boardgame_names_on_search_value_trgm"
  end
end
