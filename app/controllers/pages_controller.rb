class PagesController < ApplicationController
  def home
    @reference_date = Price.latest_update_date
    @deals = BoardgameDealsService.call.limit(8)
  end
end
