require "test_helper"


class BoardGameTest < ActiveSupport::TestCase
  def setup
    xml = file_fixture("bgg/api/v1/query_single.xml").read
    parsed = Nokogiri::XML(xml)
    @game = Bgg::BoardGame.from_xml(parsed.at_xpath("//boardgame").to_xml)
  end

  test "has the correct id" do
    assert_equal "822", @game.id
  end

  test "has the correct year" do
    assert_equal "2000", @game.year
  end

  test "has the correct primary name" do
    assert_equal "Carcassonne", @game.name
  end

  test "has a list of names" do
    assert @game.names.instance_of? Array
    assert @game.names.all? { it.instance_of? String }
  end

  test "returns nil for not found games" do
    xml = "<boardgames termsofuse=\"https://boardgamegeek.com/xmlapi/termsofuse\">\n\t\t<boardgame>\n\t\t<error message=\"Item not found\"/>\n\t</boardgame>\n</boardgames>\n"
    assert_nil Bgg::BoardGame.from_xml(xml)
  end
end
