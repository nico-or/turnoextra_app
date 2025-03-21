require "test_helper"


class BoardGameTest < ActiveSupport::TestCase
  def setup
    xml = <<~XML
<boardgame objectid="822">
<yearpublished>2000</yearpublished>
<minplayers>2</minplayers>
<maxplayers>5</maxplayers>
<playingtime>45</playingtime>
<minplaytime>30</minplaytime>
<maxplaytime>45</maxplaytime>
<age>7</age>
<name primary="true" sortindex="1">Carcassonne</name>
<name sortindex="1">Carcassonne da viaggio</name>
<name sortindex="1">Carcassonne de voyage</name>
<name sortindex="1">Carcassonne Jubilee Edition</name>
<name sortindex="1">Carcassonne: Plus</name>
<name sortindex="1">Carcassonne: Reiseditie</name>
<name sortindex="1">Domínio de Carcassonne</name>
<name sortindex="1">Reise-Carcassonne</name>
<name sortindex="1">Travel Carcassonne</name>
<name sortindex="1">Τα Κάστρα του Μυστρά</name>
<name sortindex="1">Каркасон</name>
<name sortindex="1">Каркасон</name>
<name sortindex="1">Каркассон</name>
<name sortindex="1">Средневековье</name>
<name sortindex="1">קרקסון</name>
<name sortindex="1">كاركاسون</name>
<name sortindex="1">คาร์คาซอนน์</name>
<name sortindex="1">カルカソンヌ</name>
<name sortindex="1">カルカソンヌ21</name>
<name sortindex="1">カルカソンヌＪ</name>
<name sortindex="1">卡卡城</name>
<name sortindex="1">卡卡頌</name>
<name sortindex="1">카르카손</name>
<description>
Carcassonne is a tile placement game in which the players draw and place a tile with a piece of southern French landscape represented on it. The tile might feature a city, a road, a cloister, grassland or some combination thereof, and it must be placed adjacent to tiles that have already been played, in such a way that cities are connected to cities, roads to roads, et cetera. Having placed a tile, the player can then decide to place one of their meeples in one of the areas on it: in the city as a knight, on the road as a robber, in the cloister as a monk, or in the field as a farmer. When that area is complete that meeple scores points for its owner.<br/><br/>During a game of Carcassonne, players are faced with decisions like: &quot;Is it really worth putting my last meeple there?&quot; or &quot;Should I use this tile to expand my city, or should I place it near my opponent instead, thus making it a harder for them to complete it and score points?&quot; Since players place only one tile and have the option to place one meeple on it, turns proceed quickly even if it is a game full of options and possibilities.<br/><br/>First game in the Carcassonne series.<br/><br/>
</description>
<thumbnail>
https://cf.geekdo-images.com/okM0dq_bEXnbyQTOvHfwRA__thumb/img/88274KiOg94wziybVHyW8AeOiXg=/fit-in/200x150/filters:strip_icc()/pic6544250.png
</thumbnail>
<image>
https://cf.geekdo-images.com/okM0dq_bEXnbyQTOvHfwRA__original/img/aVZEXAI-cUtuunNfPhjeHlS4fwQ=/0x0/filters:format(png)/pic6544250.png
</image>
<boardgameartist objectid="127899">Marcel Gröber</boardgameartist>
<boardgameartist objectid="14057">Chris Quilliams</boardgameartist>
<boardgameartist objectid="145317">Franz-Georg Stämmele</boardgameartist>
<boardgameartist objectid="43873">Anne Pätzke</boardgameartist>
<boardgameartist objectid="74">Doris Matthäus</boardgameartist>
<boardgamecategory objectid="1035">Medieval</boardgamecategory>
<boardgamecategory objectid="1086">Territory Building</boardgamecategory>
<boardgamedesigner objectid="398">Klaus-Jürgen Wrede</boardgamedesigner>
<boardgamegraphicdesigner objectid="145317">Franz-Georg Stämmele</boardgamegraphicdesigner>
<boardgamemechanic objectid="2002">Tile Placement</boardgamemechanic>
<boardgamemechanic objectid="2043">Enclosure</boardgamemechanic>
<boardgamemechanic objectid="2048">Pattern Building</boardgamemechanic>
<boardgamemechanic objectid="2080">Area Majority / Influence</boardgamemechanic>
<boardgamemechanic objectid="2959">Map Addition</boardgamemechanic>
<boardgamesubdomain objectid="5499">Family Games</boardgamesubdomain>
<poll name="suggested_numplayers" title="User Suggested Number of Players" totalvotes="2642">
<results numplayers="1">
<result value="Best" numvotes="7"/>
<result value="Recommended" numvotes="77"/>
<result value="Not Recommended" numvotes="1640"/>
</results>
<results numplayers="2">
<result value="Best" numvotes="1397"/>
<result value="Recommended" numvotes="948"/>
<result value="Not Recommended" numvotes="127"/>
</results>
<results numplayers="3">
<result value="Best" numvotes="1168"/>
<result value="Recommended" numvotes="1145"/>
<result value="Not Recommended" numvotes="46"/>
</results>
<results numplayers="4">
<result value="Best" numvotes="730"/>
<result value="Recommended" numvotes="1353"/>
<result value="Not Recommended" numvotes="187"/>
</results>
<results numplayers="5">
<result value="Best" numvotes="196"/>
<result value="Recommended" numvotes="1078"/>
<result value="Not Recommended" numvotes="761"/>
</results>
<results numplayers="5+">
<result value="Best" numvotes="35"/>
<result value="Recommended" numvotes="244"/>
<result value="Not Recommended" numvotes="1355"/>
</results>
</poll>
<poll-summary name="suggested_numplayers" title="User Suggested Number of Players">
<result name="bestwith" value="Best with 2 players"/>
<result name="recommmendedwith" value="Recommended with 2–5 players"/>
</poll-summary>
<poll name="language_dependence" title="Language Dependence" totalvotes="490">
<results>
<result level="1" value="No necessary in-game text" numvotes="481"/>
<result level="2" value="Some necessary text - easily memorized or small crib sheet" numvotes="7"/>
<result level="3" value="Moderate in-game text - needs crib sheet or paste ups" numvotes="1"/>
<result level="4" value="Extensive use of text - massive conversion needed to be playable" numvotes="0"/>
<result level="5" value="Unplayable in another language" numvotes="1"/>
</results>
</poll>
<poll name="suggested_playerage" title="User Suggested Player Age" totalvotes="760">
<results>
<result value="2" numvotes="2"/>
<result value="3" numvotes="1"/>
<result value="4" numvotes="12"/>
<result value="5" numvotes="55"/>
<result value="6" numvotes="228"/>
<result value="8" numvotes="351"/>
<result value="10" numvotes="89"/>
<result value="12" numvotes="18"/>
<result value="14" numvotes="3"/>
<result value="16" numvotes="1"/>
<result value="18" numvotes="0"/>
<result value="21 and up" numvotes="0"/>
</results>
</poll>
</boardgame>
XML
    @game = Bgg::BoardGame.from_xml(xml)
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
end
