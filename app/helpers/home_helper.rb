module HomeHelper
  def render_collection(collection, section_key)
    content_tag :section, class: "my-5" do
      safe_join([
        content_tag(:h2, t("pages.home.#{section_key}.title"), class: "fw-bold"),
        if collection.empty?
          content_tag(:div, t("pages.home.#{section_key}.fallback"), class: "alert alert-info")
        else
          render partial: "boardgames/grid", locals: { boardgames: collection }
        end
      ])
    end
  end
end
