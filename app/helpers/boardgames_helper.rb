module BoardgamesHelper
  def discount_tag(boardgame)
    if boardgame.respond_to?(:discount_percentage)
      content_tag(:span, " (-#{boardgame.discount_percentage}%)")
    end
  end
end
