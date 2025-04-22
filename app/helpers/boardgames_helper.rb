module BoardgamesHelper
  def discount_tag(boardgame)
    return if boardgame.reference_price == 0
    return unless boardgame.price < boardgame.reference_price

    abs_difference =  boardgame.price - boardgame.reference_price
    rel_difference = 1.0 * abs_difference / boardgame.reference_price
    discount = (100 * rel_difference).to_i

    content_tag(:span, "(#{discount}%)")
  end
end
