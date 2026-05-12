module ExternalLinkHelper
  UTM_PARAMS = {
    utm_source: "turnoextra"
  }.freeze

  def safe_url(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) ? uri.to_s : nil
  rescue URI::InvalidURIError
    nil
  end

  def umami_event_attributes(name, properties = {})
    return {} unless name.present?

    attrs = { "data-umami-event" => name }
    properties.each_with_object(attrs) do |(key, value), hash|
      hash["data-umami-event-#{key}"] = value.to_s
    end
  end
end
