require "test_helper"

class BoardgamesHelperTest < ActionView::TestCase
  include BoardgamesHelper

  test "#weight_category returns correct string" do
    Boardgame = Struct.new(:weight, :weight_category)
    [
      [1.0, :light, true],
      [1.8, :medium_light, true],
      [2.6, :medium, true],
      [3.4, :medium_heavy, true],
      [4.2, :heavy, true],
      [0.1, :unknown, false],
      [5.1, :unknown, false],
      [0, :unrated, false],
      [nil, :unrated, false],
    ].each do |(weight, weight_category, has_tail)|
      boardgame = Boardgame.new(weight, weight_category)
      human_weight = I18n.t("activerecord.attributes.boardgame.weight_category.#{boardgame.weight_category}")
      
      expected = case has_tail
      when true
        tail = "(#{boardgame.weight.round(1)}/5)"
        "#{human_weight} #{tail}"
      else
        human_weight
      end
      
      assert_equal expected, weight_category(boardgame)
    end
  end
end
