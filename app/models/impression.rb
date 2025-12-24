class Impression < ApplicationRecord
  belongs_to :trackable, polymorphic: true

  validates :trackable, presence: true
  validates :date, presence: true
  validates :count, numericality: { greater_than_or_equal_to: 0 }
  validates :trackable_id, uniqueness: { scope: [ :trackable_type, :date ] }

  before_validation :set_default_date
  before_validation :set_default_count

  private

  def set_default_date
    self.date ||= Date.current
  end

  def set_default_count
    self.count ||= 0
  end

  def self.impression_for(trackable, visitor:)
    return unless visitor.impression_worthy?

    impression = Impression.find_or_create_by(trackable: trackable, date: Date.current)
    Impression.increment_counter(:count, impression.id)
  end
end
