class BoardgamesController < ApplicationController
  skip_before_action :authorize_user, only: %i[index show]
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
