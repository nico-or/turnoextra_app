class Listing < ApplicationRecord
  belongs_to :store
  belongs_to :boardgame, optional: true
  has_many :prices
  has_many :identification_failures, as: :identifiable, dependent: :destroy

  validates :title, presence: true
  validates :url, presence: true

  scope :boardgames_only, -> { where(is_boardgame: true) }
  scope :unidentified, -> { where(boardgame_id: nil) }
  scope :failed_identification, -> { where(failed_local_identification: true, failed_bgg_api_identification: true) }
  scope :with_title_like, ->(title) { where("LOWER(listings.title) LIKE LOWER(?)", "%#{title}%") }

  def latest_price_date
    @latest_price_date ||= prices.maximum(:date)
  end

  def failed_identification?
    failed_local_identification? || failed_bgg_api_identification?
  end

  def set_failed_identification_flags(value)
    raise ArgumentError, "Invalid value for failed identification flags" unless [ true, false ].include?(value)
    update(
      failed_local_identification: value,
      failed_bgg_api_identification: value,
    )
  end
end
