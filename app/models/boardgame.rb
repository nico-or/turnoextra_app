class Boardgame < ApplicationRecord
  has_many :listings
  has_many :prices, through: :listings
  has_many :stores, through: :listings
  has_many :boardgame_names
  has_many :impressions, as: :trackable
  has_many :ranks, class_name: "Things::Rank"
  has_many :links, class_name: "Things::Link"
  has_one :boardgame_deal, class_name: "BoardgameDeal", inverse_of: :boardgame

  has_many :contact_messages, inverse_of: :contactable, dependent: :destroy

  validates :title, presence: true
  validates :year, presence: true, numericality: { only_integer: true }
  validates :bgg_id, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }
  validates :rank, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :min_players, allow_blank: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_players, allow_blank: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :min_playtime, allow_blank: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_playtime, allow_blank: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :weight, allow_blank: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  scope :has_listings, -> { joins(:listings).distinct }
  scope :without_images, -> { where("image_url IS NULL OR thumbnail_url IS NULL") }
  scope :with_title_like, ->(title) { where("LOWER(boardgames.title) LIKE LOWER(?)", "%#{title}%") }
  scope :with_similar_title, ->(title, threshold = 0.8) do
    joins(:boardgame_names)
    .select(
      "boardgames.*",
      "boardgame_names.*",
      sanitize_sql_array([ "similarity(boardgame_names.value, ?) AS similarity", title ])
    )
    .where("similarity(boardgame_names.value, ?) > ?", title, threshold)
    .order("similarity desc")
    .distinct
  end

  def latest_price_date
    @latest_price_date ||= prices.maximum(:date)
  end

  def bgg_url
    Bgg.uri_for(self).to_s
  end

  def preferred_name
    selected_name = boardgame_names.find_by(preferred: true) || boardgame_names.first
    selected_name&.value
  end

  def weight_category
    case weight
    when 0, nil then :unrated
    when 1.0...1.8 then :light
    when 1.8...2.6 then :medium_light
    when 2.6...3.4 then :medium
    when 3.4...4.2 then :medium_heavy
    when 4.2..5.0  then :heavy
    else
      :unknown
    end
  end

  def slug
    title.parameterize
  end
end
