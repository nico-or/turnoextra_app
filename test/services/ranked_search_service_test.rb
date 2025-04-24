require "test_helper"

class RankedSearchServiceTest < ActiveSupport::TestCase
  def setup
    listing = listings(:catan_1)
    @query = StringNormalizationService.normalize_title(listing.title)

    file = file_fixture("bgg/api/v1/search_catan.xml")
    url = "https://boardgamegeek.com/xmlapi/search"
    uri = URI.parse(url)
    uri.query = URI.encode_www_form({ search: @query })
    stub_request(:get, uri).to_return(body: file)

    @service = RankedSearchService.new(listing, Bgg::Versions::XmlV1)
  end

  test "#call returns an array of [Bgg::SearchResult]" do
    games = @service.call

    assert games.is_a? Array
    assert games.all? { |game| game.is_a? Bgg::SearchResult }
  end

  test "#call sorts the results correctly (Dice, then Levenshtein, then year)" do
    game = @service.call.first

    assert_equal "Los Colonos de Catán", game.name
    assert_equal 2008, game.year
    assert_equal 152959, game.id
  end

  test "can also receive string arguments" do
    service = RankedSearchService.new(@query, Bgg::Versions::XmlV1)

    assert_nothing_raised do
      results = service.call
      assert_equal 10, results.length
    end
  end
end
