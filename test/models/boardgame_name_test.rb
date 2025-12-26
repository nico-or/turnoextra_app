require "test_helper"

class BoardgameNameValidationsTest < ActiveSupport::TestCase
  def setup
    @boardgame = Boardgame.create! do |bg|
      bg.title = "Test Boardgame"
      bg.bgg_id = 123
    end
    @boardgame_name_params = { value: "Test Name", preferred: true }
  end

  test "Should be valid with all required attributes 1" do
    boardgame_name = @boardgame.boardgame_names.build(@boardgame_name_params)
    assert boardgame_name.valid?
    boardgame_name.save!
    boardgame_name.reload
    assert_equal "Test Name", boardgame_name.value
    assert boardgame_name.preferred?
  end

  test "Should be valid with all required attributes 2" do
    params = @boardgame_name_params.merge(preferred: false)
    boardgame_name = @boardgame.boardgame_names.create!(params)
    assert_equal "Test Name", boardgame_name.value
    assert_not boardgame_name.preferred?
  end

  test "Should not allow two preferred names" do
    assert_raise ActiveRecord::RecordInvalid do
      @boardgame.boardgame_names.create!(value: "Test Name 1", preferred: true)
      @boardgame.boardgame_names.create!(value: "Test Name 2", preferred: true)
    end
  end

  test "Should not allow duplicated names" do
    assert_raises ActiveRecord::RecordInvalid do
      @boardgame.boardgame_names.create!(value: "Test Name", preferred: false)
      @boardgame.boardgame_names.create!(value: "Test Name", preferred: false)
    end

    assert_raises ActiveRecord::RecordInvalid do
      @boardgame.boardgame_names.create!(value: "Test Name", preferred: true)
      @boardgame.boardgame_names.create!(value: "Test Name", preferred: false)
    end
  end

  test "Two boardgames can have the same name" do
    bg_1 = Boardgame.create!(bgg_id: 1, title: "Test Game")
    bg_2 = Boardgame.create!(bgg_id: 2, title: "Test Game")

    assert_nothing_raised do
      bg_1.boardgame_names.create!(value: "Test Game")
      bg_2.boardgame_names.create!(value: "Test Game")
    end
  end

  test "Should not be valid without a name" do
    params = @boardgame_name_params.merge(value: nil)
    boardgame_name = @boardgame.boardgame_names.build(params)
    assert_not boardgame_name.valid?
  end

  test "Should default to false for preferred" do
    params = @boardgame_name_params.merge(preferred: nil)
    boardgame_name = @boardgame.boardgame_names.create!(params)
    assert_equal false, boardgame_name.preferred
  end

  test "Boardgame should be able to access it's names" do
    @boardgame.boardgame_names.create!(value: "Preferred Name", preferred: true)
    @boardgame.boardgame_names.create!(value: "Alternate Name", preferred: false)

    names = @boardgame.boardgame_names
    assert names.all { |name| name.is_a? BoardgameName }
    assert_equal "Preferred Name", names.first.value
  end

  test "Set search value after creation" do
    bn =  @boardgame.boardgame_names.create!(value: "Avíö")

    assert_equal "avio", bn.search_value
  end

  test ".search_value" do
    assert_equal "avio", BoardgameName.search_value("avío")
    assert_equal "avio", BoardgameName.search_value("AVÏO")
  end
end
