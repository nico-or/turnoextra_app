class Listing < ApplicationRecord
  belongs_to :store
  belongs_to :boardgame, optional: true
  has_many :prices

  validates :title, presence: true
  validates :url, presence: true

  scope :boardgames_only, -> { where(is_boardgame: true) }
  scope :unidentified, -> { where(boardgame_id: nil, failed_identification: false) }
  scope :with_title_like, ->(title) { where("LOWER(listings.title) LIKE LOWER(?)", "%#{title}%") }

  def latest_price_date
    @latest_price_date ||= prices.maximum(:date)
  end
end
