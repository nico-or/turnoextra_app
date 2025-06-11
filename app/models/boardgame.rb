class Boardgame < ApplicationRecord
  has_many :listings
  has_many :prices, through: :listings
  has_many :stores, through: :listings
  has_many :daily_boardgame_deals # TODO: replace with has_one
  has_many :boardgame_names
  has_many :impressions, as: :trackable

  validates :title, presence: true
  validates :year, presence: true, numericality: { only_integer: true }
  validates :bgg_id, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }
  validates :rank, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :has_listings, -> { joins(:listings).distinct }
  scope :without_images, -> { where("image_url IS NULL OR thumbnail_url IS NULL") }
  scope :with_title_like, ->(title) { where("LOWER(boardgames.title) LIKE LOWER(?)", "%#{title}%") }
  scope :with_similar_title, ->(title, threshold = 0.8) do
    joins(:boardgame_names)
    .select(
      "boardgames.*",
      "boardgame_names.*",
      sanitize_sql_array([ "similarity(boardgame_names.value, ?) AS similarity", title ])
    )
    .where("similarity(boardgame_names.value, ?) > ?", title, threshold)
    .order("similarity desc")
    .distinct
  end

  def latest_price_date
    @latest_price_date ||= prices.maximum(:date)
  end

  def bgg_url
    Bgg.uri_for(self).to_s
  end

  def preferred_name
    selected_name = boardgame_names.find_by(preferred: true) || boardgame_names.first
    selected_name&.value
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end
end
