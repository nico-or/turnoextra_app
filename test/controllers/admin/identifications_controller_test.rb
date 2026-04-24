require "test_helper"
class Admin::IdentificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_admin

    @boardgame = Boardgame.first

    @listing = Listing.create(
      title: "test game",
      url: "https://www.example.com/test_game",
      store: Store.first,
    )
  end

  test "GET #index" do
    get admin_identifications_path
    assert_response :success
  end

  test "GET #new without query" do
    get new_admin_identification_path

    assert_response :success
  end

  test "GET #new with query" do
    stub_request(:get, %r{https://boardgamegeek\.com/xmlapi.?/search})

    get new_admin_identification_path, params: { bgg_query: "test search" }

    assert_response :success
  end

  test "POST #create with a valid bgg_id" do
    post admin_identifications_path, params: { listing_ids: [ @listing.id ], bgg_id: @boardgame.bgg_id }

    assert_redirected_to admin_identifications_path

    @listing.reload

    assert @listing.identified?
    assert_equal @listing.boardgame, @boardgame
  end

  test "POST #create with an invalid bgg_id" do
    post admin_identifications_path, params: { listing_ids: [ @listing.id ], bgg_id: -1 }

    assert_redirected_to admin_identifications_path

    @listing.reload

    assert @listing.pending?
    assert_nil @listing.boardgame
  end

  test "POST #mark_as_not_boardgame should update a listing correctly" do
    post admin_identifications_path, params: { listing_ids: [ @listing.id ], bgg_id: @boardgame.bgg_id }
    post mark_as_not_boardgame_admin_identifications_path, params: { listing_ids: [ @listing.id ] }

    assert_redirected_to admin_identifications_path

    @listing.reload

    assert @listing.rejected?
    assert_nil @listing.boardgame
  end
end
