require "test_helper"
require "minitest/mock"

class Bgg::BoardgameMetadataUpdaterTest < ActiveSupport::TestCase
  def setup
    @boardgame = Boardgame.create(title: "Old Game", year: 2019, bgg_id: 123)
    @bgg_boardgame = Bgg::Boardgame.new(
      bgg_id: 123,
      year: 2020,
      title: "New Game",
      titles: [ "New Game", "Another Title" ],
      description: "A new game!",
      thumbnail_url: "http://example.com/thumbnail.jpg",
      image_url: "http://example.com/image.jpg"
    )
  end

  test "update_boardgame_details" do
    client_stub = Minitest::Mock.new
    client_stub.expect(:boardgame, [ @bgg_boardgame ], [ Integer ])

    Bgg::BoardgameMetadataUpdater.new(@boardgame.bgg_id, client: client_stub).call

    @boardgame.reload

    assert_equal @bgg_boardgame.bgg_id, @boardgame.bgg_id
    assert_equal @bgg_boardgame.year, @boardgame.year
    assert_equal @bgg_boardgame.title, @boardgame.title
    @bgg_boardgame.titles.each do |names|
      assert_includes @boardgame.boardgame_names.pluck(:value), names
    end
    assert_equal @bgg_boardgame.thumbnail_url, @boardgame.thumbnail_url
    assert_equal @bgg_boardgame.image_url, @boardgame.image_url
  end

  test "Should not create duplicated boardgame names" do
    client_stub = Minitest::Mock.new
    client_stub.expect(:boardgame, [ @bgg_boardgame ], [ Integer ])

    Bgg::BoardgameMetadataUpdater.new(@boardgame.bgg_id, client: client_stub).call

    @new_bgg_boardgame = @bgg_boardgame.with(titles: [ "New Game", "New Game", "Another Title", "Test Name" ])

    client_stub.expect(:boardgame, [ @new_bgg_boardgame ], [ Integer ])

    assert_difference("@boardgame.boardgame_names.count", 1) do
      Bgg::BoardgameMetadataUpdater.new(@boardgame.bgg_id, client: client_stub).call
    end
  end
end
