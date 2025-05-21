class BoardgameName < ApplicationRecord
  belongs_to :boardgame

  validates :value, presence: true, uniqueness: { scope: :boardgame_id }
  validates :preferred, inclusion: { in: [ true, false ] }

  validate :only_one_preferred_name_per_boardgame, on: :create

  before_validation :set_preferred_default, on: :create

  private

  def set_preferred_default
    self.preferred ||= false
  end

  def only_one_preferred_name_per_boardgame
    return unless preferred
    existing_preferred = BoardgameName.where(boardgame_id: boardgame_id, preferred: true).exists?
    if existing_preferred
      errors.add(:preferred, "can only be one preferred alternate name per boardgame")
    end
  end
end
