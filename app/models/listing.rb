class Listing < ApplicationRecord
  belongs_to :store
  belongs_to :boardgame
  has_many :prices

  def latest_price
    prices.order(date: :desc).first
  end
end
