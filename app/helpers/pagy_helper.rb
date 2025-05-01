module PagyHelper
  def pagy_nav_link(label:, page:, aria_label:, path_helper:, rel:)
    options = { role: "button", "aria-label": aria_label, rel: rel }

    if page
      link_to label, path_helper.call(page), **options.merge("aria-disabled": false)
    else
      link_to label, "javascript:void(0)", **options.merge("aria-disabled": true, disabled: true)
    end
  end
end
