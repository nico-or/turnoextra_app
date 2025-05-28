module SearchMethod
  class DatabaseSearch
    attr_reader :query

    def initialize(query)
      @query = query
    end

    def call
      local_results.map { |boardgame| build_result(boardgame) }
    end

    private

    def build_result(boardgame)
      SearchResult.new(
        bgg_id: boardgame.bgg_id,
        year: boardgame.year,
        title: boardgame.title,
        similarity: boardgame.similarity,
        rank: boardgame.rank
      )
    end

    def quoted_query
      @quoted_query ||= ActiveRecord::Base.connection.quote(query)
    end

    def fuzzy_search(relation:, column:, alias_column: nil)
      quoted_filter = ActiveRecord::Base.sanitize_sql_array([ "#{column} % ?",  query ]) # brakeman warnings

      relation
        .where(quoted_filter)
        .where("rank > 0")
        .select(
          "boardgames.bgg_id",
          "boardgames.rank",
          "boardgames.year",
          "#{column} AS #{alias_column || 'title'}",
          "similarity(#{column}, #{quoted_query}) AS similarity"
        )
    end

    def local_results
      (local_boardgames + local_boardgame_names + local_listings)
    end

    def local_boardgames
      fuzzy_search(
        relation: Boardgame.all,
        column: "boardgames.title"
      )
    end

    def local_boardgame_names
      fuzzy_search(
        relation: Boardgame.joins(:boardgame_names),
        column: "boardgame_names.value",
        alias_column: "title"
      )
    end

    def local_listings
      fuzzy_search(
        relation: Boardgame.joins(:listings),
        column: "listings.title"
      )
    end
  end
end
