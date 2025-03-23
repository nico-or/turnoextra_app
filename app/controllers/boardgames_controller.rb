class BoardgamesController < ApplicationController
  def index
    @query = params[:q]
    if @query.present?
      @boardgames = Boardgame.where("title LIKE ?", "%#{@query}%")
    else
      @boardgames = []
    end
  end

  def show
    @boardgame = Boardgame.find(params[:id])
  end
end
