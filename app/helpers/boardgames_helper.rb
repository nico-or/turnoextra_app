module BoardgamesHelper
  def discount_tag(boardgame)
    return if boardgame.reference_price == 0
    return unless boardgame.price < boardgame.reference_price

    rel_price = boardgame.price.to_f / boardgame.reference_price
    discount = (100 * (1 - rel_price)).round

    content_tag(:span, "(-#{discount}%)")
  end
end
