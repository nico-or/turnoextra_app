class Price < ApplicationRecord
  belongs_to :listing

  validates :date, presence: true
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
