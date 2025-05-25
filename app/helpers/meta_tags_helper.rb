module MetaTagsHelper
  def default_meta_tags
    {
      site: I18n.translate("app.name"),
      description: I18n.translate("app.description"),
      separator: "|".html_safe,
      canonical: request.original_url,
      charset: "utf-8",
      reverse: true,
      og: {
        title: :title,
        description: I18n.translate("app.opengraph.description"),
        type: "website",
        url: request.original_url,
        site_name: t("app.name"),
        locale: I18n.locale.to_s,
        image: asset_url("logo.svg")
      }
    }
  end
end
