require "test_helper"

class BoardgameTest < ActiveSupport::TestCase
  def setup
    @default_params = { title: "New Game", bgg_id: 123, year: 2023 }
    @boardgame = Boardgame.new(@default_params)
  end

  test "should not allow empty titles" do
    boardgame = Boardgame.new(title: "", bgg_id: "12345")
    assert_not boardgame.valid?
  end

  test "should not allow missing titles" do
    boardgame = Boardgame.new(title: nil, bgg_id: "12345")
    assert_not boardgame.valid?
  end

  test "should not allow duplicate bgg_id" do
    boardgame = Boardgame.new(
      title: "New Game",
      bgg_id: boardgames(:pandemic).bgg_id
    )
    assert_not boardgame.valid?
  end

  test "should not allow negative bgg_id" do
    boardgame = Boardgame.new(title: "New Game", bgg_id: -1)
    assert_not boardgame.valid?
  end
  test "should not allow non-integer bgg_id" do
    boardgame = Boardgame.new(title: "New Game", bgg_id: "abc")
    assert_not boardgame.valid?
  end

  test "should not allow floating point bgg_id" do
    boardgame = Boardgame.new(title: "New Game", bgg_id: 123.45)
    assert_not boardgame.valid?
  end

  test "returns date of latest price update" do
    boardgame = boardgames(:pandemic)
    price = prices(:price_9)
    assert_equal price.date, boardgame.latest_price_date
  end

  test "#bgg_url returns returns correct BoardGameGeek url for a boardgame" do
    boardgame = boardgames(:pandemic)
    boardgame_url = "https://boardgamegeek.com/boardgame/#{boardgame.bgg_id}"
    assert_equal boardgame_url, boardgame.bgg_url
  end

  test "should not allow string as year" do
    @boardgame.year = "abc"
    assert_not @boardgame.valid?
  end

  test "should not allows floats as year" do
    @boardgame.year = 1.2
    assert_not @boardgame.valid?
  end

  test "should not allow empty year" do
    @boardgame.year = ""
    assert_not @boardgame.valid?
  end

  test "should not allow nil year" do
    @boardgame.year = nil
    assert_not @boardgame.valid?
  end

  test "should allow negative years" do
    @boardgame.year = -100
    assert @boardgame.valid?
  end

  test "should allow integer years" do
    @boardgame.year = 2023
    assert @boardgame.valid?
  end

  test "should allow zero years" do
    @boardgame.year = 0
    assert @boardgame.valid?
  end

  test "should not allow nil ranks" do
    @boardgame.rank = nil
    assert_not @boardgame.valid?
  end

  test "should not allow negative ranks" do
    @boardgame.rank = -1
    assert_not @boardgame.valid?
  end

  test "should not non-numeric ranks" do
    @boardgame.rank = "test"
    assert_not @boardgame.valid?

    @boardgame.rank = :test
    assert_not @boardgame.valid?
  end

  test "valid min_players values" do
    values = [ "", nil, 1, "2", 0 ]
    values.each do |value|
      @boardgame.min_players = value
      assert @boardgame.valid?, "Expected #{value.inspect} to be valid for \#min_players"
    end
  end

  test "invalid min_players values" do
    values = [ -1, "a", -1.1, 0.0, 2.2 ]
    values.each do |value|
      @boardgame.min_players = value
      assert_not @boardgame.valid?, "Expected #{value.inspect} to be invalid for \#min_players"
    end
  end

    test "valid max_players values" do
    values = [ "", nil, 1, "2", 0 ]
    values.each do |value|
      @boardgame.max_players = value
      assert @boardgame.valid?, "Expected #{value.inspect} to be valid for \#max_players"
    end
  end

  test "invalid max_players values" do
    values = [ -1, "a", -1.1, 0.0, 2.2 ]
    values.each do |value|
      @boardgame.max_players = value
      assert_not @boardgame.valid?, "Expected #{value.inspect} to be invalid for \#max_players"
    end
  end

  test "valid min_playtime values" do
    values = [ "", nil, 1, "2", 0 ]
    values.each do |value|
      @boardgame.min_playtime = value
      assert @boardgame.valid?, "Expected #{value.inspect} to be valid for \#min_playtime"
    end
  end

  test "invalid min_playtime values" do
    values = [ -1, "a", -1.1, 0.0, 2.2 ]
    values.each do |value|
      @boardgame.min_playtime = value
      assert_not @boardgame.valid?, "Expected #{value.inspect} to be invalid for \#min_playtime"
    end
  end

    test "valid max_playtime values" do
    values = [ "", nil, 1, "2", 0 ]
    values.each do |value|
      @boardgame.max_playtime = value
      assert @boardgame.valid?, "Expected #{value.inspect} to be valid for \#max_playtime"
    end
  end

  test "invalid max_playtime values" do
    values = [ -1, "a", -1.1, 0.0, 2.2 ]
    values.each do |value|
      @boardgame.max_playtime = value
      assert_not @boardgame.valid?, "Expected #{value.inspect} to be invalid for \#max_playtime"
    end
  end

  test "valid weight values" do
    values = [ nil, 0, 1.0, 5.0, 2.3, 4, "2.043" ]
    values.each do |value|
      @boardgame.weight = value
      assert @boardgame.valid?, "Expected #{value.inspect} to be valid for \#weight"
    end
  end

  test "invalid weight values" do
    values = [ -2.3, 5.01, "a" ]
    values.each do |value|
      @boardgame.weight = value
      assert_not @boardgame.valid?, "Expected #{value.inspect} to be invalid for \#weight"
    end
  end
end

class BoardgamePreferredNameTest < ActiveSupport::TestCase
  def setup
    @boardgame = Boardgame.create! do |bg|
      bg.title = "Test Boardgame"
      bg.bgg_id = 123
    end
  end

  test "Should return the preferred name if it exists" do
    @boardgame.boardgame_names.create!(value: "Alternate Name", preferred: false)
    @boardgame.boardgame_names.create!(value: "Preferred Name", preferred: true)
    assert_equal "Preferred Name", @boardgame.preferred_name
  end

  test "Should return the first name if no preferred name exists" do
    @boardgame.boardgame_names.create!(value: "First Name", preferred: false)
    @boardgame.boardgame_names.create!(value: "Second Name", preferred: false)
    assert_equal "First Name", @boardgame.preferred_name
  end

  test "Should return nil if no names exist" do
    assert_nil @boardgame.preferred_name
  end
end
