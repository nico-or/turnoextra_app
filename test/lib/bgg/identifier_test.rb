require "test_helper"
require "minitest/mock"


class Bgg::IdentifierTest < ActiveSupport::TestCase
  def setup
    xml = file_fixture("bgg/api/v1/search_catan.xml").read
    parsed = Nokogiri::XML(xml)
    results = parsed.xpath("//boardgame").map do |node|
      Bgg::SearchResult.new(
        id: node[:objectid],
        name: node.at_xpath("name")&.text,
        year: node.at_xpath("yearpublished")&.text
      )
    end

    # in this test, the query must be _normalized_ to avoid a Mock error
    # in production this will be either scrapped data or user input
    @query = "colonos catan"
    api_mock = Minitest::Mock.new
    api_mock.expect(:search, results, [ @query ])
    @identifier = Bgg::Identifier.new(api_mock)
  end

  test "#identify! returns an array of [Bgg::SearchResult]" do
    p games = @identifier.identify!(@query)
    p game = games.first

    assert games.is_a? Array
    assert games.all? { |game| game.is_a? Bgg::SearchResult }
    assert_equal "Los Colonos de Catán", game.name
    assert_equal "2008", game.year
    assert_equal "152959", game.id
  end

  test "#identify! sorts the results correctly (Dice, then Levenshtein, then year)" do
    game = @identifier.identify!(@query).first

    assert_equal "Los Colonos de Catán", game.name
    assert_equal "2008", game.year
    assert_equal "152959", game.id
  end
end
