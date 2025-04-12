class Store < ApplicationRecord
  has_many :listings
  has_many :boardgames, through: :listings

  validates :name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
end
