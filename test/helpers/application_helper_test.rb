require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  include ApplicationHelper

  test "#number_range returns empty string if min is blank" do
    assert_equal "", number_range(nil, 4)
    assert_equal "", number_range("", 4)
  end

  test "#number_range returns empty string if max is blank" do
    assert_equal "", number_range(1, nil)
    assert_equal "", number_range(1, "")
  end

  test "#number_range returns single value when min equals max (as strings)" do
    assert_equal "3", number_range(3, 3)
    assert_equal "3", number_range("3", 3)
    assert_equal "3", number_range(3, "3")
  end

  test "#number_range returns range with en dash by default" do
    assert_equal "2 – 4", strip_tags(number_range(2, 4))
  end

  test "#number_range returns range with custom separator" do
    assert_equal "2 to 4", strip_tags(number_range(2, 4, "to"))
    assert_equal "2 → 4",  strip_tags(number_range(2, 4, "&rarr;"))
    assert_equal "2 → 4",  strip_tags(number_range(2, 4, "&rarr;".html_safe))
  end
end
