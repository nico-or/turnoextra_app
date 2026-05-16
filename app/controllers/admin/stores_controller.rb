module Admin
  class StoresController < AdminController
    def index
      @stores = Store.all.order(name: :asc)
    end

    def show
      @store = Store.find(params[:id])
    end
  end
end
