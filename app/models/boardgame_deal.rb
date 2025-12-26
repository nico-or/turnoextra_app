class BoardgameDeal < ApplicationRecord
  belongs_to :boardgame, foreign_key: :id

  scope :with_boardgame_card_data, -> {
    select(
      "id",
      "title",
      "thumbnail_url",
      "t_price AS best_price",
      "m_price AS reference_price",
      "rel_discount_100 AS discount",
    )
    .where("t_price > 0")
  }

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: true, cascade: false)
  end

  def self.populated?
    Scenic.database.populated?(table_name)
  end

  def readonly?
    true
  end

  # Friendly URL
  def to_param
    "#{id}-#{title.parameterize}"
  end
end
