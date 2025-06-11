class DailyBoardgameDeal < ApplicationRecord
  REFERENCE_WINDOW_SIZE = 2.weeks

  belongs_to :boardgame

  validates :best_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :reference_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :discount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
