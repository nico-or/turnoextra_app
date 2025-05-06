module Admin
  class ListingsController < AdminController
    def index
      @pagy, @listings = pagy(Listing.includes(:store).all.order(title: :asc), limit: 10)
    end

    def show
      @listing = Listing.find(params[:id])
    end

    def unidentify
      @listing = Listing.find(params[:id])
      @listing.update(boardgame_id: nil, failed_identification: true)
      redirect_to admin_listing_path(@listing), notice: "Listing has been unlinked."
    end
  end
end
