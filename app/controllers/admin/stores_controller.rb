module Admin
  class StoresController < AdminController
    def index
      @stores = Store.all.order(name: :asc)
    end

    def show
      @store = Store.find(params[:id])
    end

    def new
      @store = Store.new
    end

    def edit
      @store = Store.find(params[:id])
    end

    def create
      @store = Store.new(store_params)

      if @store.save
        flash[:notice] = "Store created"
        redirect_to admin_store_path(@store)
      else
        flash[:alert] = "Errors: #{@store.errors.full_messages}"
        render :new, status: :unprocessable_entity
      end
    end

    def update
      store = Store.find(params[:id])
      if store.update(store_params)
        flash[:notice] = "Store updated"
        redirect_to admin_store_path(store)
      else
        flash[:alert] = "Errors: #{@store.errors.full_messages}"
        render :new, status: :unprocessable_entity
      end
    end

    private

    def store_params
      params.require(:store).permit(:name, :url, :status)
    end
  end
end
