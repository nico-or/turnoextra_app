class BoardgamesController < ApplicationController
  def index
    @boardgames = Boardgame.all
  end

  def show
    @boardgame = Boardgame.find(params[:id])
  end
end
