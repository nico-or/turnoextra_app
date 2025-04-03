module Admin
  class BoardgamesController < AdminController
    def index
      @boardgames = Boardgame.all
    end

    def show
      @boardgame = Boardgame.find(params[:id])
    end
  end
end
