require "test_helper"

class RankedSearchServiceTest < ActiveSupport::TestCase
  test "#call with a boardgame that is in the database" do
    boardgame = Boardgame.first
    @service = RankedSearchService.new(boardgame.title)
    results = @service.call

    assert results.is_a? Array
    assert results.all? { |result| result.is_a? Bgg::SearchResult }

    result = results.first
    assert_equal boardgame.title, result.name
    assert_equal boardgame.year, result.year
    assert_equal boardgame.bgg_id, result.id
  end

  test "#call with a listing that is in the database" do
    # binding.irb
    listing = Listing.joins(:boardgame).first
    assert_not_nil listing
    boardgame = listing.boardgame
    assert_not_nil boardgame

    @service = RankedSearchService.new(listing.title)
    results = @service.call

    assert results.is_a? Array
    assert results.all? { |result| result.is_a? Bgg::SearchResult }

    result = results.first
    assert_equal listing.title, result.name
    assert_equal boardgame.year, result.year
    assert_equal boardgame.bgg_id, result.id
  end

  test "#call with a boardgame that is not in the database" do
    query = "colonos catan"
    @service = RankedSearchService.new(query)

    file = file_fixture("bgg/api/v2/search_catan.xml")
    url = %r{https://boardgamegeek.com/xmlapi2/search}
    stub_request(:get, url).to_return(body: file)

    results = @service.call
    assert results.is_a? Array
    assert results.all? { |result| result.is_a? Bgg::SearchResult }

    result = results.first
    assert_equal "Los Colonos de Catán", result.name
    assert_equal 2008, result.year
    assert_equal 152959, result.id
  end
end
