class AddPgTrgmExtensionToDatabase < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pg_trgm'
      add_index :boardgame_names, :value, using: :gin, opclass: :gin_trgm_ops, name: "index_boardgame_names_on_value_trgm"
  end
end
