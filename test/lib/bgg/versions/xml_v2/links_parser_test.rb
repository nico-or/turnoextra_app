require "test_helper"

module Bgg::Versions::XmlV2
  class LinksParserTest < ActiveSupport::TestCase
    test "parses a single link correctly" do
      xml = <<~XML
        <item>
          <link type="boardgamecategory" id="1030" value="Party Game" />
          <versions>
            <item type="boardgameversion" id="251972">
              <link type="boardgameversion" id="165628" value="HINT" inbound="true" />
            </item>
          </versions>
        </item>
      XML

      node = Nokogiri::XML.parse(xml).first_element_child
      links = LinksParser.parse(node)

      assert_instance_of Array, links
      assert_equal 1, links.length

      link = links[0]

      assert_equal "boardgamecategory", link.type
      assert_equal 1030, link.id
      assert_equal "Party Game", link.value
    end

    test "parses multiple links correctly" do
      xml = <<~XML
        <item>
          <link type="boardgamecategory" id="1030" value="Party Game" />
		      <link type="boardgamemechanic" id="2073" value="Acting" />
          <versions>
            <item type="boardgameversion" id="251972">
              <link type="boardgameversion" id="165628" value="HINT" inbound="true" />
            </item>
          </versions>
        </item>
      XML

      node = Nokogiri::XML.parse(xml).first_element_child
      links = LinksParser.parse(node)

      assert_instance_of Array, links
      assert_equal 2, links.length

      link = links[0]
      assert_equal "boardgamecategory", link.type
      assert_equal 1030, link.id
      assert_equal "Party Game", link.value

      link = links[1]
      assert_equal "boardgamemechanic", link.type
      assert_equal 2073, link.id
      assert_equal "Acting", link.value
    end
  end
end
