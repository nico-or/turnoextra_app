require "test_helper"

module Bgg::Versions::XmlV2
  class StatisticsParserTest < ActiveSupport::TestCase
    test "parses multiple ranks correctly" do
      xml = <<~XML
        <statistics page="1">
          <ratings>
            <usersrated value="4296"/>
            <average value="7.21274"/>
            <bayesaverage value="6.58138"/>
            <ranks>
              <rank type="subtype" id="1" name="boardgame" friendlyname="Board Game Rank" value="1095" bayesaverage="6.58138"/>
              <rank type="family" id="5498" name="partygames" friendlyname="Party Game Rank" value="49" bayesaverage="6.86248"/>
            </ranks>
            <stddev value="1.26677"/>
            <median value="0"/>
            <owned value="8347"/>
            <trading value="117"/>
            <wanting value="71"/>
            <wishing value="901"/>
            <numcomments value="624"/>
            <numweights value="110"/>
            <averageweight value="1.0727"/>
          </ratings>
        </statistics>
      XML
      doc = Nokogiri::XML.parse(xml)
      statistics_node = doc.at_xpath("//statistics")

      stats = StatisticsParser.parse(statistics_node)

      assert stats.is_a?(Bgg::Statistics)

      assert_equal 4296, stats.usersrated
      assert_equal 7.21274, stats.average
      assert_equal 6.58138, stats.bayesaverage
      assert_equal 1.26677, stats.stddev
      assert_equal 0, stats.median
      assert_equal 8347, stats.owned
      assert_equal 117, stats.trading
      assert_equal 71, stats.wanting
      assert_equal 901, stats.wishing
      assert_equal 624, stats.numcomments
      assert_equal 110, stats.numweights
      assert_equal 1.0727, stats.averageweight

      assert_equal 2, stats.ranks.length

      rank = stats.ranks[0]
      assert_equal "subtype", rank.type
      assert_equal 1, rank.id
      assert_equal "boardgame", rank.name
      assert_equal "Board Game Rank", rank.friendlyname
      assert_equal 1095, rank.value
      assert_equal 6.58138, rank.bayesaverage

      rank = stats.ranks[1]
      assert_equal "family", rank.type
      assert_equal 5498, rank.id
      assert_equal "partygames", rank.name
      assert_equal "Party Game Rank", rank.friendlyname
      assert_equal 49, rank.value
      assert_equal 6.86248, rank.bayesaverage
    end
  end
end
