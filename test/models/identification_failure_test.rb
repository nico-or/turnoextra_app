require "test_helper"

class IdentificationFailureTest < ActiveSupport::TestCase
  def setup
    @listing = Listing.first
  end

  test "should create identification failure" do
    identification = IdentificationFailure.create!(identifiable: @listing, search_method: "test_search_method")

    assert_not identification.nil?
  end

  test "should not allow duplicate search method for the same identifiable" do
    identification_1 = IdentificationFailure.create!(identifiable: @listing, search_method: "test_search_method")
    identification_2 = IdentificationFailure.new(identifiable: @listing, search_method: "test_search_method")
    assert_not identification_2.valid?
  end
end
