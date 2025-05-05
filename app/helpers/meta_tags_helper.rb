module MetaTagsHelper
  def default_meta_tags
    {
      site: I18n.translate("app.name"),
      description: I18n.translate("app.description"),
      separator: "|".html_safe,
      canonical: request.original_url,
      charset: "utf-8",
      og: {
        title: :title,
        description: I18n.translate("app.opengraph.description"),
        type: "website",
        url: request.original_url,
        site_name: t("app.name"),
        locale: I18n.locale.to_s
      }
    }
  end

  def opengraph_description_for(boardgame, discount: 0)
    short_title = truncate(boardgame.title, length: 40)

    if discount < 10
      I18n.translate("boardgames.show.opengraph.description", title: short_title)
    else
      I18n.translate("boardgames.show.opengraph.description_discount", title: short_title, discount: discount)
    end
  end
end
