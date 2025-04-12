class Store < ApplicationRecord
  has_many :listings

  validates :name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
end
