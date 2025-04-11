class Boardgame < ApplicationRecord
  has_many :listings
  has_many :prices, through: :listings

  validates :title, presence: true
  validates :bgg_id, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }

  def update_date
    prices.pluck(:date).max
  end

  def bgg_url
    "https://boardgamegeek.com/boardgame/#{bgg_id}"
  end
end
