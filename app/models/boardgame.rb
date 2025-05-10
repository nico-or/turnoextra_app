class Boardgame < ApplicationRecord
  has_many :listings
  has_many :prices, through: :listings
  has_many :stores, through: :listings

  validates :title, presence: true
  validates :year, presence: true, numericality: { only_integer: true }
  validates :bgg_id, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }

  validates :reference_price, allow_blank: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :best_price, allow_blank: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :discount, allow_blank: true, numericality: { only_integer: true }

  scope :has_listings, -> { joins(:listings).distinct }
  scope :without_images, -> { where("image_url IS NULL OR thumbnail_url IS NULL") }
  scope :with_title_like, ->(title) { where("LOWER(boardgames.title) LIKE LOWER(?)", "%#{title}%") }

  def latest_price_date
    @latest_price_date ||= prices.maximum(:date)
  end

  def bgg_url
    Bgg.uri_for(self).to_s
  end
end
