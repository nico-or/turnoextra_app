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
    @boardgame = Boardgame.find(params[:id])

    @chart_data = line_chart
  end

  private

  def line_chart
    @boardgame.listings.map do |listing|
      {
        name: listing.store.name,
        data: listing.prices.order(:date).pluck(:date, :amount)
      }
    end
  end
end
