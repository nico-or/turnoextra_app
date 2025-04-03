module Admin
  class StoresController < AdminController
    def index
      @pagy, @stores = pagy(Store.all.order(name: :asc), limit: 10)
    end

    def show
      @store = Store.find(params[:id])
    end
  end
end
