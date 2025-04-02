require "test_helper"

class Bgg::ApiTest < ActiveSupport::TestCase
  def setup
    @api = Bgg::Api.new
  end

  test "#search returns an Array<Bgg::SearchResults>" do
    file = file_fixture("bgg/api/v1/search_catan.xml")
    query = "Colonos Catán"
    fragment = URI.encode_uri_component(query)
    url = "http://www.boardgamegeek.com/xmlapi/search?search=#{fragment}"
    stub_request(:get, url).to_return(body: file)

    response = @api.search(query)

    assert response.is_a? Array
    assert_equal 10, response.size
    assert response.all? { it.is_a? Bgg::SearchResult }

    game = response[1]

    assert_equal "Catan Historias: Los Colonos de Europa", game.name
    assert_equal "2011", game.year
    assert_equal "103091", game.id
  end

  test "#find_by_id returns an Array<Bgg::BoardGame>" do
    bgg_id = "822"
    file = file_fixture("bgg/api/v1/query_single.xml")
    url = "http://www.boardgamegeek.com/xmlapi/boardgame/#{bgg_id}"
    stub_request(:get, url).to_return(body: file)

    response = @api.find_by_id(bgg_id)

    assert response.is_a? Array
    assert response.all? { it.is_a? Bgg::BoardGame }
    assert_equal 1, response.size

    game = response.first

    assert_equal "Carcassonne", game.name
    assert_equal "2000", game.year
    assert_equal bgg_id, game.id
    assert_equal 23, game.names.size
  end
end
