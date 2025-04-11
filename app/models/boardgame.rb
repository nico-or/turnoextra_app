class Boardgame < ApplicationRecord
  has_many :listings
  has_many :prices, through: :listings

  def update_date
    prices.pluck(:date).max
  end

  def bgg_url
    "https://boardgamegeek.com/boardgame/#{bgg_id}"
  end
end
