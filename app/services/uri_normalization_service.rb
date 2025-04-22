class UriNormalizationService < ApplicationService
  def initialize(url)
    @url = url
  end

  def call
    URI.parse(@url).origin.downcase
  rescue StandardError
    nil
  end
end
