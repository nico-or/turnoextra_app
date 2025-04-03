module Admin
  class BoardgamesController < AdminController
    def index
      @pagy, @boardgames = pagy(Boardgame.all.order(title: :asc), limit: 10)
    end

    def show
      @boardgame = Boardgame.find(params[:id])
    end
  end
end
