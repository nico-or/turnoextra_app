require "test_helper"

class ImpressionValidatorTest < ActiveSupport::TestCase
  test "visitor is worthy" do
    user = nil
    assert ImpressionValidator.new(user:).worthy?
  end

  test "regular user is worthy" do
    user = users(:user)
    assert ImpressionValidator.new(user:).worthy?
  end

  test "admin is not worthy" do
    user = users(:admin)
    assert_not ImpressionValidator.new(user:).worthy?
  end
end
