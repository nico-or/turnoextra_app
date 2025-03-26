class Boardgame < ApplicationRecord
  has_many :listings
  has_many :prices, through: :listings

  # lowest price between listings.
  def latest_price
    prices.order(date: :desc, price: :asc).first
  end

  def update_date
    prices.pluck(:date).max
  end
end
