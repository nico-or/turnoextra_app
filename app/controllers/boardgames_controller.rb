class BoardgamesController < ApplicationController
  def index
    @boardgames = Boardgame.where.associated(:listings).distinct

    if params[:q].present?
      @boardgames = @boardgames.where("boardgames.title LIKE ?", "%#{params[:q]}%")
    end
  end

  def show
    @boardgame = Boardgame.find(params[:id])
  end
end
