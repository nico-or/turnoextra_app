class Listing < ApplicationRecord
  belongs_to :store
  belongs_to :boardgame
  has_many :prices
end
