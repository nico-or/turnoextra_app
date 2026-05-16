class Store < ApplicationRecord
  has_many :listings
  has_many :boardgames, through: :listings

  enum :status, {
    pending: "pending", # new store, pending spider setup
    active: "active",   # store that is up and being crawled
    closed: "closed"    # store that is permanently closed
  }, default: "pending"

  validates :name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
end
