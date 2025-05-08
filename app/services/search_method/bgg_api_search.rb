class SearchMethod::BggApiSearch
  attr_reader :query, :client

  def initialize(query)
    @query = query
    @client = Bgg::Client.new
  end

  def call
    client.search(normalized_query)
  end

  private

  def normalized_query
    StringNormalizationService.normalize_string(query)
  end
end
