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

  def tracking_url(url)
    base_url = safe_url(url)
    return nil unless base_url

    uri = URI.parse(base_url)
    query = Rack::Utils.parse_nested_query(uri.query).merge(UTM_PARAMS)
    uri.query = Rack::Utils.build_query(query)
    uri.to_s
  end

  def umami_event_attributes(name, properties = {})
    return {} unless name.present?

    attrs = { "data-umami-event" => name }
    properties.each_with_object(attrs) do |(key, value), hash|
      hash["data-umami-event-#{key}"] = value.to_s
    end
  end
end
