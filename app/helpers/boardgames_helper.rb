module BoardgamesHelper
  def discount_tag(boardgame)
    return unless boardgame.discount.present? && boardgame.discount > 0

    content_tag(:span, "(-#{boardgame.discount}%)")
  end
end
