class SearchController < ApplicationController
  def search
    query = params[:q]
    quoted_query = ActiveRecord::Base.connection.quote(query)

    reference_date = DailyBoardgameDeal.latest_update_date

    boardgames = Boardgame
      .joins(:daily_boardgame_deals)
      .joins(:boardgame_names)
      .where("boardgame_names.value %> ?", query)
      .where(daily_boardgame_deals: { date: reference_date })
      .select(
        "boardgames.id",
        "boardgames.title",
        "boardgames.thumbnail_url",
        "daily_boardgame_deals.discount",
        "daily_boardgame_deals.best_price",
        "daily_boardgame_deals.reference_price",
        "MAX(word_similarity(#{quoted_query}, boardgame_names.value)) AS similarity")
      .group(
        "boardgames.id",
        "boardgames.thumbnail_url",
        "daily_boardgame_deals.discount",
        "daily_boardgame_deals.best_price",
        "daily_boardgame_deals.reference_price")
      .order(Arel.sql("MAX(word_similarity(#{quoted_query}, boardgame_names.value)) DESC"))

    @pagy, @boardgames = pagy(boardgames, limit: 12)
  end
end
