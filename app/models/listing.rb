class Listing < ApplicationRecord
  belongs_to :store
  belongs_to :boardgame, optional: true
  has_many :prices

  def latest_price_date
    @latest_price_date ||= prices.maximum(:date)
  end
end
