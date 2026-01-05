xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @static_pages.each do |page_data|
    xml.url do
      xml.loc page_data[:url]
      xml.lastmod page_data[:lastmod].try(:iso8601) if page_data[:lastmod]
      xml.changefreq page_data[:changefreq] if page_data[:changefreq]
      xml.priority page_data[:priority] if page_data[:priority]
    end
  end

  @boardgames.each do |boardgame|
    xml.url do
      xml.loc slugged_boardgame_url(boardgame, slug: boardgame.slug)
      xml.lastmod boardgame.lastmod.try(:iso8601) if boardgame.respond_to?(:lastmod)
      xml.changefreq "daily"
      xml.priority "1.0"
    end
  end
end
