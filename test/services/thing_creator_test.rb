require "test_helper"

class ThingCreatorTest < ActiveSupport::TestCase
  setup do
    @boardgame = Bgg::Boardgame.new(
      bgg_id: 123,
      year: 2025,
      title: "Test Boardgame",
      titles: [ "Test Boardgame", "Juego de Prueba" ],
      description: "Lorem ipsum.",
      image_url: "https://www.example.com/images/01.jpg",
      thumbnail_url: "https://www.example.com/images/01-thumb.jpg",
      min_players: 1,
      max_players: 4,
      min_playtime: 10,
      max_playtime: 45,
      playingtime: 45,
      statistics: Bgg::Statistics.new(
        usersrated: nil,
        average: nil,
        bayesaverage: nil,
        ranks: nil,
        stddev: nil,
        median: nil,
        owned: nil,
        trading: nil,
        wanting: nil,
        wishing: nil,
        numcomments: nil,
        numweights: nil,
        averageweight: 3.1415,
      ),
      links: [],
    )
  end

  test "#create! creates the relevant database records" do
    boardgame = ThingCreator.new(@boardgame).create!

    assert_instance_of ::Boardgame, boardgame
    assert boardgame.persisted?

    assert_equal @boardgame.bgg_id, boardgame.bgg_id
    assert_equal @boardgame.year, boardgame.year
    assert_equal @boardgame.title, boardgame.title
    assert_equal @boardgame.titles, boardgame.boardgame_names.pluck(:value)
    assert_equal @boardgame.image_url, boardgame.image_url
    assert_equal @boardgame.thumbnail_url, boardgame.thumbnail_url
    assert_equal @boardgame.min_players, boardgame.min_players
    assert_equal @boardgame.max_players, boardgame.max_players
    assert_equal @boardgame.min_playtime, boardgame.min_playtime
    assert_equal @boardgame.max_playtime, boardgame.max_playtime
    assert_equal @boardgame.weight, boardgame.weight
  end

  test "#create! updates the boardgame record correctly" do
    boardgame = ThingCreator.new(@boardgame).create!

    new_boardgame = Bgg::Boardgame.new(
      bgg_id: @boardgame.bgg_id,
      year: @boardgame.year + 1,
      title: "New Boardgame",
      titles: [ "New Boardgame", "Nuevo juego de prueba" ],
      description: "FooBar.",
      image_url: "https://www.example.com/images/02.jpg",
      thumbnail_url: "https://www.example.com/images/02-thumb.jpg",
      min_players: @boardgame.min_players + 1,
      max_players: @boardgame.max_players + 1,
      min_playtime: @boardgame.min_playtime + 1,
      max_playtime: @boardgame.max_playtime + 1,
      playingtime: @boardgame.playingtime + 1,
      statistics: nil,
      links: [],
    )

    ThingCreator.new(new_boardgame).create!
    boardgame.reload

    assert_equal new_boardgame.bgg_id, boardgame.bgg_id
    assert_equal new_boardgame.year, boardgame.year
    assert_equal new_boardgame.title, boardgame.title
    # TODO: should all previous names be deleted when updating ?
    # assert_equal new_boardgame.titles, boardgame.boardgame_names.map(&:value)
    assert_equal new_boardgame.image_url, boardgame.image_url
    assert_equal new_boardgame.thumbnail_url, boardgame.thumbnail_url
    assert_equal new_boardgame.min_players, boardgame.min_players
    assert_equal new_boardgame.max_players, boardgame.max_players
    assert_equal new_boardgame.min_playtime, boardgame.min_playtime
    assert_equal new_boardgame.max_playtime, boardgame.max_playtime
  end

  test "#create! is idempotent for the same BGG id" do
    creator = ThingCreator.new(@boardgame)
    creator.create!
    assert_no_difference("Boardgame.count", "BoardgameName.count") do
      creator.create!
    end
  end

  test "#create! doesn't add repeated boardgame names" do
    ThingCreator.new(@boardgame).create!

    new_boardgame = @boardgame.with(titles: [ "Test Boardgame", "Juego de Prueba", "FooBar" ])
    boardgame = ThingCreator.new(new_boardgame).create!

    assert_equal 3, boardgame.boardgame_names.count
  end
end
