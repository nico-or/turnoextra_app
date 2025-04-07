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
  end
end
