require "test_helper"
require "webmock/minitest"

class Bgg::ClientTest < ActiveSupport::TestCase
  test "defaults to Bgg::Versions::XmlV2::Client" do
    client = Bgg::Client.new
    assert_instance_of Bgg::Versions::XmlV2::Client, client.instance_variable_get(:@client)
  end

  test "with :xml_v1 version argument it raises an ArgumentError" do
    assert_raises(ArgumentError) { Bgg::Client.new(:xml_v1) }
  end

  test "with :xml_v2 version argument uses Bgg::Versions::XmlV2::Client" do
    client = Bgg::Client.new(:xml_v2)
    assert_instance_of Bgg::Versions::XmlV2::Client, client.instance_variable_get(:@client)
  end

  test "raises ArgumentError with unsupported version argument" do
    assert_raises(ArgumentError) { Bgg::Client.new(:json) }
  end
end

class Bgg::ClientXmlV2Test < ActiveSupport::TestCase
  def setup
    Rails.cache.clear
    @client = Bgg::Client.new(:xml_v2)
    @default_params = Bgg::Versions::XmlV2::Api.default_params

    @search_url = %r{https://boardgamegeek.com/xmlapi2/search}
    @boardgame_url = %r{https://boardgamegeek.com/xmlapi2/thing}
  end

  test "#search should cache results" do
    query = "test"
    params = @default_params.merge({ query: query }).to_param
    stub_request(:get, @search_url).to_return(status: 200).to_raise(RuntimeError)

    assert_nothing_raised do
      2.times { @client.search(query) }
    end

    travel Bgg::Client::TTL + 1.second do
      assert_raises(RuntimeError) { @client.search(query) }
    end
  end

  test "#boardgame should cache results" do
    id = [ 1, 2, 3 ]
    params = @default_params.merge({ id: id.join(",") }).to_param
    stub_request(:get, @boardgame_url).to_return(status: 200).to_raise(RuntimeError)

    assert_nothing_raised do
      2.times { @client.boardgame(id) }
    end

    travel Bgg::Client::TTL + 1.second do
      assert_raises(RuntimeError) { @client.boardgame(id) }
    end
  end

  test "#search returns an empty array if API responds with error code" do
    stub_request(:get, @search_url).to_return(status: 400)
    result = @client.search("test query")
    assert_kind_of Array, result
    assert result.empty?

    stub_request(:get, @search_url).to_return(status: 500)
    result = @client.search("test query")
    assert_kind_of Array, result
    assert result.empty?
  end

  test "#boardgame returns an empty array if API responds with error code" do
    stub_request(:get, @boardgame_url).to_return(status: 400)
    result = @client.boardgame(123)
    assert_kind_of Array, result
    assert result.empty?

    stub_request(:get, @boardgame_url).to_return(status: 500)
    result = @client.boardgame(123)
    assert_kind_of Array, result
    assert result.empty?
  end

  test "#search sends a custom user agent" do
    stub_request(:get, @search_url).to_return(status: 200)

    @client.search("test query")

    assert_requested :get, @search_url,
    headers: { "User-Agent" => Bgg::Client::USER_AGENT }
  end

    test "#boardgame sends a custom user agent" do
    stub_request(:get, @boardgame_url).to_return(status: 200)

    @client.boardgame(123)

    assert_requested :get, @boardgame_url,
    headers: { "User-Agent" => Bgg::Client::USER_AGENT }
  end
end
