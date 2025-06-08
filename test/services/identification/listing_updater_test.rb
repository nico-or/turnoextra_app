require "test_helper"
require "ostruct"
require "minitest/mock"

module Identification
class ListingUpdaterTest < ActiveSupport::TestCase
  setup do
    @store = Store.first

    @boardgame = Boardgame.create!(title: "Test Boardgame", bgg_id: 1)

    @l1 = @store.listings.new(title: "test game", url: "https://example.com/listing/1")
    @l2 = @store.listings.new(title: "Test Game", url: "https://example.com/listing/2")
    @l3 = @store.listings.new(title: "Another Game", url: "https://example.com/listing/3")

    @fail_reason = "test reason"
    @search_method = "SearchMethod::TestSearch"

    @logger = Logger.new(STDOUT, level: :fatal)
    @listing_updater = ListingUpdater.new(@l1, logger: @logger)
  end

  test "identify_all!" do
    [ @l1, @l2, @l3 ].each(&:save!)

    count = @listing_updater.identify_all!(@boardgame)

    assert_equal 2, count

    [ @l1, @l2, @l3 ].each(&:reload)

    assert_equal @boardgame.id, @l1.boardgame_id
    assert_equal @boardgame.id, @l2.boardgame_id
    assert_nil @l3.boardgame_id
  end


  test "identify_all! when already identified v1" do
    [ @l1, @l2, @l3 ].each(&:save!)

    @l1.update(boardgame: @boardgame)

    count = @listing_updater.identify_all!(@boardgame)

    assert_equal 1, count

    [ @l1, @l2, @l3 ].each(&:reload)

    assert_equal @boardgame.id, @l1.boardgame_id
    assert_equal @boardgame.id, @l2.boardgame_id
    assert_nil @l3.boardgame_id
  end

  test "identify_all! when already identified v2" do
    [ @l1, @l2, @l3 ].each(&:save!)

    @l2.update(boardgame: @boardgame)

    count = @listing_updater.identify_all!(@boardgame)

    assert_equal 1, count

    [ @l1, @l2, @l3 ].each(&:reload)

    assert_equal @boardgame.id, @l1.boardgame_id
    assert_equal @boardgame.id, @l2.boardgame_id
    assert_nil @l3.boardgame_id
  end

  test "fail_all!" do
    [ @l1, @l2, @l3 ].each(&:save!)

    assert_difference("IdentificationFailure.count", 2) do
      count = @listing_updater.fail_all!(@fail_reason, @search_method)

      assert_equal 2, count
    end

    [ @l1, @l2, @l3 ].each(&:reload)

    assert_not @l1.identification_failures.empty?
    assert_not @l2.identification_failures.empty?
    assert @l3.identification_failures.empty?
  end
end
end
