require "test_helper"


class SearchResultTest < ActiveSupport::TestCase
  def setup
    xml = "<boardgame objectid=\"375090\">\n  <name primary=\"true\">3rd World Labour: Pandemic Edition</name>\n  <yearpublished>2022</yearpublished>\n</boardgame>"
    @result = Bgg::SearchResult.from_xml(xml)
  end

  test "has the correct name" do
    assert_equal "3rd World Labour: Pandemic Edition", @result.name
  end

  test "has the correct id" do
    assert_equal "375090", @result.id
  end

  test "has the correct year" do
    assert_equal "2022", @result.year
  end
end
