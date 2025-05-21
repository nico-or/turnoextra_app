class Boardgame < ApplicationRecord
  has_many :listings
  has_many :prices, through: :listings
  has_many :stores, through: :listings
  has_many :daily_boardgame_deals
  has_many :boardgame_names

  validates :title, presence: true
  validates :year, presence: true, numericality: { only_integer: true }
  validates :bgg_id, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }
  validates :rank, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :has_listings, -> { joins(:listings).distinct }
  scope :without_images, -> { where("image_url IS NULL OR thumbnail_url IS NULL") }
  scope :with_title_like, ->(title) { where("LOWER(boardgames.title) LIKE LOWER(?)", "%#{title}%") }

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
end
