require "test_helper"


class Bgg::SingleBoardGameQueryTest < ActiveSupport::TestCase
  def setup
    xml = file_fixture("bgg/api/v1/query_single.xml").read
    parsed = Nokogiri::XML(xml)
    @search = Bgg::BoardGameQuery.new(parsed)
  end

  test "#games returns an array of BoardGames" do
    games = @search.games

    assert games.is_a? Array
    assert games.all? { |game| game.is_a? Bgg::BoardGame }
  end

  test "buils the correct BoardGame" do
    game = @search.games.first

    assert_equal "822", game.id
    assert_equal "2000", game.year
    assert_equal "Carcassonne", game.name
    assert_equal 23, game.names.count
  end
end

class Bgg::MultipleBoardGameQueryTest < ActiveSupport::TestCase
  def setup
    xml = file_fixture("bgg/api/v1/query_multiple.xml").read
    parsed = Nokogiri::XML(xml)
    @search = Bgg::BoardGameQuery.new(parsed)
  end

  test "#games returns an array of BoardGames" do
    games = @search.games

    assert_equal 2, games.count
    assert games.is_a? Array
    assert games.all? { |game| game.is_a? Bgg::BoardGame }
  end
end

class Bgg::NotFoundBoardGameQueryTest < ActiveSupport::TestCase
  def setup
    xml = file_fixture("bgg/api/v1/query_not_found.xml").read
    parsed = Nokogiri::XML(xml)
    @search = Bgg::BoardGameQuery.new(parsed)
  end

  test "#games returns an empty array" do
    games = @search.games

    assert games.empty?
    assert games.is_a? Array
  end
end
