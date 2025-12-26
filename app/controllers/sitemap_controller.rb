class SitemapController < ApplicationController
  XML_URL_LIMIT = 45_000

  def index
    @boardgames = boardgames_data
    @static_pages = static_pages_data

    if @boardgames.size == XML_URL_LIMIT
      Rails.logger.error(self.class.name) { "hit sitemap limit of #{XML_URL_LIMIT} boardgames" }
    end

    respond_to do |format|
      format.xml { render layout: false }
    end
  end

  private

  def static_pages_data
    [
      { url: root_url, priority: "0.6" },
      { url: faq_url, priority: "0.4" }
    ]
  end

  def boardgames_data
    BoardgameDeal
      .select("id", "title")
      .limit(XML_URL_LIMIT)
  end
end
