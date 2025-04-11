class BoardgamesController < ApplicationController
  skip_before_action :authorize_user, only: %i[index show]
  def index
    latest_date = Price.maximum(:date)

    @boardgames = Boardgame.joins(listings: [ :prices ])
                           .where(prices: { date: latest_date })
                           .order(:title)
                           .group("boardgames.id")
                           .select("boardgames.*, MIN(prices.amount) AS latest_price")
                           .distinct

    if params[:q].present?
      @boardgames = @boardgames.where("boardgames.title LIKE ?", "%#{params[:q]}%")
    end

    @pagy, @boardgames = pagy(@boardgames, limit: 10)
  end

  def show
    @boardgame = Boardgame.includes(listings: [ :prices, :store ]).find(params[:id])

    latest_date = @boardgame.prices.maximum(:date)

    @listings_with_best_price = @boardgame.listings.filter_map do |listing|
      best_price = listing.prices
                          .select { |p| p.date == latest_date }
                          .min(&:amount)
      next unless best_price

      [ listing, best_price ]
    end

    @listings_with_best_price.sort_by! { |(_l, p)| [ p.amount ] }

    @chart_data = chart_data
  end

  private

  def date_range
    (Date.today - 1.month)..Date.today
  end

  def chart_data
    listings = @boardgame.listings.includes(:store)

    prices = @boardgame.prices
                       .select { |price| date_range.include?(price.date) }
                       .each_with_object({}) do |price, hash|
                         hash[[ price.listing_id, price.date ]] ||= price.amount
                       end

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
