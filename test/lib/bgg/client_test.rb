require "test_helper"

class Bgg::ClientTest < ActiveSupport::TestCase
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
end
