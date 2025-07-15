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
      thumbnail_url: "https://www.example.com/images/01-thumb.jpg"
    )
  end

  test "#create! creates the relevant database records" do
    boardgame = ThingCreator.new(@boardgame).create!

    assert boardgame.persisted?

    assert_instance_of ::Boardgame, boardgame
    assert_equal 123, boardgame.bgg_id
    assert_equal 2025, boardgame.year
    assert_equal "Test Boardgame", boardgame.title
    assert_equal [ "Test Boardgame", "Juego de Prueba" ], boardgame.boardgame_names.map(&:value)
    assert_equal "https://www.example.com/images/01.jpg", boardgame.image_url
    assert_equal "https://www.example.com/images/01-thumb.jpg", boardgame.thumbnail_url
  end

  test "#create! updates the boardgame record correctly" do
    boardgame = ThingCreator.new(@boardgame).create!
    assert_equal @boardgame.title, boardgame.title

    boardgame = ThingCreator.new(@boardgame.with(title: "New Name")).create!
    assert_equal "New Name", boardgame.title
  end

  test "#create! is idempotent for the same BGG id" do
    creator = ThingCreator.new(@boardgame)
    creator.create!
    assert_no_difference("Boardgame.count", "BoardgameName.count") do
      creator.create!
    end
  end
end
