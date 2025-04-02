require "test_helper"

class Bgg::IdentifierTest < ActiveSupport::TestCase
  def setup
    file = file_fixture("bgg/api/v1/search_catan.xml")
    url = "https://www.boardgamegeek.com/xmlapi/search?search=colonos%20catan"
    stub_request(:get, url).to_return(body: file)

    @query = "Colonos Catán"
    @identifier = Bgg::Identifier.new
  end

  test "#identify! returns an array of [Bgg::SearchResult]" do
    games = @identifier.identify!(@query)

    assert games.is_a? Array
    assert games.all? { |game| game.is_a? Bgg::SearchResult }
  end

  test "#identify! sorts the results correctly (Dice, then Levenshtein, then year)" do
    game = @identifier.identify!(@query).first

    assert_equal "Los Colonos de Catán", game.name
    assert_equal "2008", game.year
    assert_equal "152959", game.id
  end
end
