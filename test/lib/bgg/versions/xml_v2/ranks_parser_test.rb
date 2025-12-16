require "test_helper"

module Bgg::Versions::XmlV2
  class RanksParserTest < ActiveSupport::TestCase
    test "parses a single rank correctly" do
      xml = '<ranks><rank type="subtype" id="1" name="boardgame" friendlyname="Board Game Rank" value="1095" bayesaverage="6.58138"/></ranks>'
      node = Nokogiri::XML.parse(xml)

      rank = RanksParser.parse(node).first

      assert_equal "subtype", rank.type
      assert_equal 1, rank.id
      assert_equal "boardgame", rank.name
      assert_equal "Board Game Rank", rank.friendlyname
      assert_equal 1095, rank.value
      assert_equal 6.58138, rank.bayesaverage
    end

    test "parses a single unraked rank correctly" do
      xml = <<~XML
        <ranks>
          <rank type="subtype" id="1" name="boardgame" friendlyname="Board Game Rank" value="Not Ranked" bayesaverage="Not Ranked" />
        </ranks>
      XML
      node = Nokogiri::XML.parse(xml)

      rank = RanksParser.parse(node).first

      assert_equal "subtype", rank.type
      assert_equal 1, rank.id
      assert_equal "boardgame", rank.name
      assert_equal "Board Game Rank", rank.friendlyname
      assert_equal 0, rank.value
      assert_equal 0, rank.bayesaverage
    end

    test "parses multiple ranks correctly" do
      xml = <<~XML
        <ranks>
          <rank type="subtype" id="1" name="boardgame" friendlyname="Board Game Rank" value="1095" bayesaverage="6.58138"/>
          <rank type="family" id="5498" name="partygames" friendlyname="Party Game Rank" value="49" bayesaverage="6.86248"/>
        </ranks>
      XML
      node = Nokogiri::XML.parse(xml)

      ranks = RanksParser.parse(node)

      assert ranks.is_a?(Array)
      assert ranks.length.eql?(2)

      rank = ranks[0]
      assert_equal "subtype", rank.type
      assert_equal 1, rank.id
      assert_equal "boardgame", rank.name
      assert_equal "Board Game Rank", rank.friendlyname
      assert_equal 1095, rank.value
      assert_equal 6.58138, rank.bayesaverage

      rank = ranks[1]
      assert_equal "family", rank.type
      assert_equal 5498, rank.id
      assert_equal "partygames", rank.name
      assert_equal "Party Game Rank", rank.friendlyname
      assert_equal 49, rank.value
      assert_equal 6.86248, rank.bayesaverage
    end
  end
end
