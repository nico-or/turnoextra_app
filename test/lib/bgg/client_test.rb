require "test_helper"
require "webmock/minitest"

class Bgg::ClientTest < ActiveSupport::TestCase
  def setup
    Rails.cache.clear
    @client = Bgg::Client.new
  end

  test "defaults to Bgg::Versions::XmlV1::Client" do
    client = Bgg::Client.new
    assert_instance_of Bgg::Versions::XmlV1::Client, client.instance_variable_get(:@client)
  end

  test "with :xml_v1 version argument uses Bgg::Versions::XmlV1::Client" do
    client = Bgg::Client.new(:xml_v1)
    assert_instance_of Bgg::Versions::XmlV1::Client, client.instance_variable_get(:@client)
  end

  test "with :xml_v2 version argument uses Bgg::Versions::XmlV2::Client" do
    client = Bgg::Client.new(:xml_v2)
    assert_instance_of Bgg::Versions::XmlV2::Client, client.instance_variable_get(:@client)
  end

  test "raises ArgumentError with unsupported version argument" do
    assert_raises(ArgumentError) { Bgg::Client.new(:json) }
  end

  test "should cache search results" do
    query = "test"
    stub_request(:get, "https://boardgamegeek.com/xmlapi/search?search=test").to_return(status: 200).to_raise(RuntimeError)

    assert_nothing_raised do
      2.times { @client.search(query) }
    end

    travel Bgg::Client::TTL + 1.second do
      assert_raises(RuntimeError) { @client.search(query) }
    end
  end

  test "should cache boardgame results" do
    id = [ 1, 2, 3 ]
    stub_request(:get, "https://boardgamegeek.com/xmlapi/boardgame/1,2,3").to_return(status: 200).to_raise(RuntimeError)

    assert_nothing_raised do
      2.times { @client.boardgame(id) }
    end

    travel Bgg::Client::TTL + 1.second do
      assert_raises(RuntimeError) { @client.boardgame(id) }
    end
  end
end
