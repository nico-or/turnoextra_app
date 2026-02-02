module Admin
  class StoreSuggestionsController < AdminController
    def index
      @store_suggestions_tally = StoreSuggestion
        .select("store_suggestions.url", "COUNT(*) AS count")
        .group(:url)
        .order("count DESC")
    end
  end
end
