class SearchController < ApplicationController
  def search
    query = Text::Normalization.search_value(params[:q])
    quoted_query = ActiveRecord::Base.connection.quote(query)

    similarities = BoardgameName
      .select(
        "boardgame_id",
        "word_similarity(#{quoted_query}, search_value) AS sim")
      .where("? <% search_value", query)

    boardgames = BoardgameDeal
      .with(similarities:)
      .joins("JOIN similarities s ON s.boardgame_id = boardgame_deals.id")
      .with_boardgame_card_data
      .group(
        "id",
        "rank",
        "title",
        "thumbnail_url",
        "rel_discount_100",
        "t_price",
        "m_price"
      )
      .order(
        "MAX(sim) DESC",
        Arel.sql("NULLIF(rank, 0) ASC NULLS LAST"),
        "title ASC")

    @pagy, @boardgames = pagy(boardgames, limit: 12)
  end
end
