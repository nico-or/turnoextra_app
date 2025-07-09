require "test_helper"

module Bgg::Versions::XmlV2
  class ClientTest < ActiveSupport::TestCase
    setup do
      @client = Client.new
    end

    test "#search makes a GET request to the search endpoint" do
      query = "example"
      url = "https://boardgamegeek.com/xmlapi2/search?query=#{query}&type=boardgame,boardgameexpansion,rpgitem"
      stub_request(:get, url)
      @client.search(query)
      assert_requested :get, url
    end

    test "#boardgame makes a GET request to the thing endpoint with a single id" do
      bgg_id = 822
      url = "https://boardgamegeek.com/xmlapi2/thing?id=#{bgg_id}&type=boardgame,boardgameexpansion,rpgitem"
      stub_request(:get, url)
      @client.boardgame(bgg_id)
      assert_requested :get, url
    end

    test "#boardgame makes a GET request to the boardgame endpoint with multiple ids" do
      bgg_id = [ 10, 20, 30 ]
      url = "https://boardgamegeek.com/xmlapi2/thing?id=#{bgg_id.join(',')}&type=boardgame,boardgameexpansion,rpgitem"
      stub_request(:get, url)
      @client.boardgame(*bgg_id)
      assert_requested :get, url
    end

    test "#boardgame accepts multiple ids as an array and makes a GET request to the boardgame endpoint with those ids" do
      bgg_id = [ 10, 20, 30 ]
      url = "https://boardgamegeek.com/xmlapi2/thing?id=#{bgg_id.join(',')}&type=boardgame,boardgameexpansion,rpgitem"
      stub_request(:get, url)
      @client.boardgame(bgg_id)
      assert_requested :get, url
    end

    test "#boardgame should raise when more than 20 ids are provided" do
     bgg_id = Array.new(21) { rand(1..100) }
      assert_raises ArgumentError do
        @client.boardgame(*bgg_id)
      end
    end

    test "#boardgame accepts stats parameter" do
      bgg_id = 42
      url = "https://boardgamegeek.com/xmlapi2/thing?id=#{bgg_id}&type=boardgame,boardgameexpansion,rpgitem&stats=1"
      stub_request(:get, url)
      @client.boardgame(bgg_id, stats: true)
      assert_requested :get, url
    end

    test "#boardgame accepts versions parameter" do
      bgg_id = 42
      url = "https://boardgamegeek.com/xmlapi2/thing?id=#{bgg_id}&type=boardgame,boardgameexpansion,rpgitem&versions=1"
      stub_request(:get, url)
      @client.boardgame(bgg_id, versions: true)
      assert_requested :get, url
    end

    test "#boardgame accepts both stats and versions parameters" do
      bgg_id = 42
      url = "https://boardgamegeek.com/xmlapi2/thing?id=#{bgg_id}&type=boardgame,boardgameexpansion,rpgitem&stats=1&versions=1"
      stub_request(:get, url)
      @client.boardgame(bgg_id, stats: true, versions: true)
      assert_requested :get, url
    end

    test "#boardgame ignores unsupported parameters" do
      bgg_id = 42
      url = "https://boardgamegeek.com/xmlapi2/thing?id=#{bgg_id}&type=boardgame,boardgameexpansion,rpgitem"
      stub_request(:get, url)
      @client.boardgame(bgg_id, unsupported_param: true)
      assert_requested :get, url
    end
  end
end
