module ApplicationHelper
  def number_range(min, max, separator = "&ndash;")
    return "" if [ min, max ].any?(&:blank?)

    return min.to_s if min.to_s == max.to_s

    safe_join([ min, separator.html_safe, max ], " ")
  end
end
