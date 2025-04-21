class PagesController < ApplicationController
  skip_before_action :authorize_user

  def home
    @reference_date = Price.latest_update_date
    @deals = BoardgameDealsService.new(reference_date: @reference_date).call.limit(8)
  end
end
