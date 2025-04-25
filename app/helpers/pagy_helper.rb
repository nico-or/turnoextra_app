module PagyHelper
  def pagy_nav_link(label, page, aria_label, path_helper)
    if page
      link_to label, path_helper.call(page), aria_label: aria_label, aria_disabled: false, role: "button"
    else
      link_to label, "javascript:void(0)", aria_label: aria_label, aria_disabled: true, role: "button", disabled: true
    end
  end
end
