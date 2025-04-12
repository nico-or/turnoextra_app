require "test_helper"

class StoreTest < ActiveSupport::TestCase
  setup do
    @params = {
      name: "Example Store",
      url: "http://example.com"
    }
  end

  test "should create store" do
    assert_difference("Store.count") do
      Store.create(@params)
    end
  end

  test "should not create store without name" do
    @params[:name] = nil
    store = Store.new(@params)
    assert_not store.valid?
    assert_no_difference("Store.count") do
      store.save
    end
  end

  test "should not create store without url" do
    @params[:url] = nil
    store = Store.new(@params)
    assert_not store.valid?
    assert_no_difference("Store.count") do
      store.save
    end
  end

  test "should not allow duplicate name" do
    Store.create(@params)
    assert_no_difference("Store.count") do
      Store.create(@params.merge(url: "http://example.org"))
    end
  end

  test "should not allow duplicate url" do
    Store.create(@params)
    assert_no_difference("Store.count") do
      Store.create(@params.merge(name: "Example Store 2"))
    end
  end
end
