class PagesController < ApplicationController
  def home
    @reference_date = Price.latest_update_date
    @deals = BoardgameDealsService.new(reference_date: @reference_date).call.limit(8)
  end
end
