class StoreSuggestion < ApplicationRecord
  validates :url, presence: true
  validate :valid_store_url?

  before_validation :normalize_url

  private

  def valid_store_url?
    valid_uri = URI.regexp.match?(self.url)
    valid_scheme = URI.parse(self.url).kind_of?(URI::HTTP) rescue nil
    unless  valid_uri && valid_scheme
      errors.add(:url, "must be a valid HTTP or HTTPS URL")
    end
  end

  def normalize_url
    self.url = UriNormalizationService.call(self.url)
  end
end
