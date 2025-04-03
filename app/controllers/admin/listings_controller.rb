module Admin
  class ListingsController < AdminController
    def index
      @pagy, @listings = pagy(Listing.all.order(title: :asc), limit: 10)
    end

    def show
      @listing = Listing.find(params[:id])
    end
  end
end
