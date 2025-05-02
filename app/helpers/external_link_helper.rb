module ExternalLinkHelper
  def safe_url(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) ? uri.to_s : nil
  rescue URI::InvalidURIError
    nil
  end
end
