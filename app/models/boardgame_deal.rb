class BoardgameDeal < ApplicationRecord
  belongs_to :boardgame, foreign_key: :id

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: true, cascade: false)
  end

  def self.populated?
    Scenic.database.populated?(table_name)
  end

  def readonly?
    true
  end
end
