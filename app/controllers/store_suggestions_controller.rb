class StoreSuggestionsController < ApplicationController
  rate_limit to: 5, within: 1.minute, with: -> { redirect_to new_store_suggestion_path, alert: "Rate limit exceeded. Please try again later." }, only: [ :create ]

  def index
    @store_suggestions_tally = StoreSuggestion.select("store_suggestions.url", "COUNT(*) AS count")
                                              .group(:url)
                                              .order("count DESC")
                                              .limit(10)
  end

  def new
    @store_suggestion = StoreSuggestion.new
  end

  def create
    @store_suggestion = StoreSuggestion.new(store_suggestion_params)

    if @store_suggestion.save
      redirect_to new_store_suggestion_path, notice: t(".success")
    else
      flash[:alert] = t(".failure")
      render :new
    end
  end

  private

  def store_suggestion_params
    params.require(:store_suggestion).permit(:url)
  end
end
