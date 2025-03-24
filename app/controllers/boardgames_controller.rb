class BoardgamesController < ApplicationController
  def index
    @query = params[:q]
    if @query.present?
      @boardgames = Boardgame.where("boardgames.title LIKE ?", "%#{@query}%")
                             .where.associated(:listings)
                             .distinct
    else
      @boardgames = []
    end
  end

  def show
    @boardgame = Boardgame.find(params[:id])
  end
end
