require "test_helper"

class Admin::ListingsControllerUserTest < ActionDispatch::IntegrationTest
  test "should not get index" do
    get admin_listings_url
    assert_redirected_to login_path
  end
end

class Admin::ListingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_admin
  end

  test "should get index" do
    get admin_listings_url
    assert_response :success
  end

  test "should get show" do
    listing = listings(:pandemic_1)
    get admin_listing_url(listing)
    assert_response :success
  end

  test "should get show with bgg_query" do
    stub_request(:get, %r{https://boardgamegeek\.com/xmlapi.?/search})

    listing = listings(:pandemic_1)
    get admin_listing_url(listing), params: { bgg_query: "Catan" }
    assert_response :success
  end
end



class Admin::ListingsControllerIdentifyTest < ActionDispatch::IntegrationTest
  setup do
    login_admin

    @listing = Listing.create! do |l|
      l.title = "New Game"
      l.url = "http://example.com/new-game"
      l.store = Store.first
      l.boardgame_id = nil
      l.failed_identification = true
      l.is_boardgame = false
    end
  end
  test "should patch identify" do
    boardgame = Boardgame.first
    new_id = boardgame.bgg_id

    assert_not_equal boardgame, @listing.boardgame
    patch identify_admin_listing_path(@listing), params: { bgg_id: new_id }
    assert_redirected_to admin_listing_path(@listing)
    @listing.reload
    assert_equal boardgame, @listing.boardgame
    assert @listing.is_boardgame
    assert_not @listing.failed_identification
  end

  test "should not patch identify with invalid id" do
    new_id = 1
    assert_nil Boardgame.find_by(bgg_id: new_id)

    patch identify_admin_listing_path(@listing), params: { bgg_id: new_id }
    assert_redirected_to admin_listing_path(@listing)
    @listing.reload
    assert_nil @listing.boardgame
    assert_not @listing.is_boardgame
    assert @listing.failed_identification
  end
end

class Admin::ListingsControllerUnidentifyTest < ActionDispatch::IntegrationTest
  setup do
    login_admin
    @boardgame = Boardgame.first

    @listing = Listing.create! do |l|
      l.title = "New Game"
      l.url = "http://example.com/new-game"
      l.store = Store.first
      l.boardgame = @boardgame
    end
  end

  test "should patch unidentify" do
    assert_equal @boardgame, @listing.boardgame

    patch unidentify_admin_listing_path(@listing)
    @listing.reload

    assert_nil @listing.boardgame
    assert @listing.failed_identification
    assert @listing.is_boardgame
  end
end
