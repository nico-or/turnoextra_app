module PlaceholdHelper
  def placehold_img(width, **kwargs)
    image_tag("https://placehold.co/#{width}", **kwargs)
  end
end
