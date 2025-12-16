module BoardgamesHelper
  def discount_tag(boardgame)
    return unless boardgame.discount.present? && boardgame.discount > 0

    content_tag(:span, "(-#{boardgame.discount}%)")
  end

  def weight_category(boardgame)
    human_weight = I18n.t("activerecord.attributes.boardgame.weight_category.#{boardgame.weight_category}")

    case boardgame.weight_category
    when :unrated, :unknown
      human_weight
    else
    "#{human_weight} (#{boardgame.weight.round(1)}/5)"
    end
  end
end
