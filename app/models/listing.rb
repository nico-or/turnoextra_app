class Listing < ApplicationRecord
  belongs_to :store
  belongs_to :boardgame
  has_many :prices


  def latest_price
    prices.where(date: update_date)
          .order(price: :asc)
          .first
  end

  def update_date
    prices.pluck(:date).max
  end
end
