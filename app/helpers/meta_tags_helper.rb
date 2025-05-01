module MetaTagsHelper
  def default_meta_tags
    {
      site: I18n.translate("app.name"),
      description: I18n.translate("app.description"),
      separator: "|".html_safe,
      canonical: request.original_url,
      og: {
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        site_name: t("app.name"),
        locale: I18n.locale.to_s
      }
    }
  end
end
