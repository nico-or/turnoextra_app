require "test_helper"

module Bgg::Versions::XmlV1
  class ApiTest < ActiveSupport::TestCase
    test "#search makes a GET request to the search endpoint" do
      query = "example"
      url = "https://boardgamegeek.com/xmlapi/search?search=#{query}"
      stub_request(:get, url)
      Api.search(query)
      assert_requested :get, url
    end

    test "#boardgame makes a GET request to the boardgame endpoint with a single id" do
      bgg_id = 822
      url = "https://boardgamegeek.com/xmlapi/boardgame/822"
      stub_request(:get, url)
      Api.boardgame(bgg_id)
      assert_requested :get, url
    end

    test "#boardgame makes a GET request to the boardgame endpoint with multiple ids" do
      bgg_id = [ 10, 20, 30 ]
      url = "https://boardgamegeek.com/xmlapi/boardgame/10,20,30"
      stub_request(:get, url)
      Api.boardgame(*bgg_id)
      assert_requested :get, url
    end

    test "#boardgame accepts multiple ids as an array and makes a GET request to the boardgame endpoint with those ids" do
      bgg_id = [ 10, 20, 30 ]
      url = "https://boardgamegeek.com/xmlapi/boardgame/10,20,30"
      stub_request(:get, url)
      Api.boardgame(bgg_id)
      assert_requested :get, url
    end

    test "#boardgame should raise when more than 20 ids are provided" do
     bgg_id = Array.new(21) { rand(1..100) }
      assert_raises ArgumentError do
        Api.boardgame(*bgg_id)
      end
    end
  end
end
