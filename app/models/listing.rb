class Listing < ApplicationRecord
  belongs_to :store
  has_many :prices
end
