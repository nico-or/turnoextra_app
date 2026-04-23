class Listing < ApplicationRecord
  belongs_to :store
  belongs_to :boardgame, optional: true
  has_many :prices
  has_many :identification_failures, as: :identifiable, dependent: :destroy

  enum :status, {
    pending: "pending",       # new listing, hasn't been identified
    failed: "failed",         # listing failed automatic identification
    identified: "identified", # listing has a boardgame_id
    rejected: "rejected"      # listing is not a boardgame
   }, default: "pending"

  validates :title, presence: true
  validates :url, presence: true

  scope :boardgames_only, -> { where(is_boardgame: true) }
  scope :unidentified, -> { where(boardgame_id: nil) }
  scope :requires_identification, -> { boardgames_only.unidentified }
  scope :failed_identification, -> {
    failed_ids = IdentificationFailure.where(identifiable_type: "Listing").pluck(:identifiable_id)
    where(id: failed_ids)
  }
  scope :with_title_like, ->(title) { where("LOWER(listings.title) LIKE LOWER(?)", "%#{title}%") }

  def latest_price_date
    @latest_price_date ||= prices.maximum(:date)
  end

  def failed_identification?
    self.identification_failures.any?
  end
end
