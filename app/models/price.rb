class Price < ApplicationRecord
  belongs_to :listing

  validates :date, presence: true
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :with_date, ->(date) { where(date: date) }
  scope :today, -> { with_date(Date.current) }
  scope :yesterday, -> { with_date(Date.yesterday) }

  def self.latest_update_date
    maximum(:date) || DateTime.current
  end
end
