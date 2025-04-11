class Listing < ApplicationRecord
  belongs_to :store
  belongs_to :boardgame, optional: true
  has_many :prices

  def update_date
    prices.pluck(:date).max
  end
end
