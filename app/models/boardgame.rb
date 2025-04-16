class Boardgame < ApplicationRecord
  has_many :listings
  has_many :prices, through: :listings
  has_many :stores, through: :listings

  validates :title, presence: true
  validates :bgg_id, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }

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
