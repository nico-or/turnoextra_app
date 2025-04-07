class BoardgamesController < ApplicationController
  skip_before_action :authorize_user, only: %i[index show]
  def index
    @boardgames = Boardgame.where.associated(:listings).distinct.order(:title)

    if params[:q].present?
      @boardgames = @boardgames.where("boardgames.title LIKE ?", "%#{params[:q]}%")
    end

    @pagy, @boardgames = pagy(@boardgames, limit: 10)
  end

  def show
    # TODO: remove N+1 query from listing#latest_price
    # TODO: sort listings by latest_price
    @boardgame = Boardgame.includes(:listings, :prices).find(params[:id])

    @chart_data = line_chart
  end

  private

  def line_chart
    listings = @boardgame.listings.includes(:store)

    date_range = (Date.today - 1.month)..Date.today

    prices = Price.where(listing: listings, date: date_range)
                  .group(:listing_id, :date)
                  .minimum(:amount)

    listings.map do |listing|
      {
        name: listing.store.name,
        data: date_range.map do |date|
          price = prices[[ listing.id, date ]]
          [ date, price ]
        end
      }
    end
  end
end
