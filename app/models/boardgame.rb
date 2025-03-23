class Boardgame < ApplicationRecord
  has_many :listings
  has_many :prices, through: :listings

  # lowest price between listings.
  def best_price
    prices.where(date: update_date)
          .order(price: :desc)
          .first
  end

  def update_date
    prices.pluck(:date).max
  end
end
