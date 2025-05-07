module Admin
  class ListingsController < AdminController
    def index
      @pagy, @listings = pagy(Listing.includes(:store).all.order(title: :asc), limit: 10)
    end

    def show
      @listing = Listing.find(params[:id])

      if params[:bgg_query].present?
        results = Bgg::Versions::XmlV2.search(params[:bgg_query])
        boardgames = Boardgame.where(bgg_id: results.map(&:id))
      end
      @boardgames = boardgames || []
    end

    def identify
      @listing = Listing.find(params[:id])
      boardgame = Boardgame.find_by(bgg_id: params[:bgg_id])
      if boardgame.present?
        @listing.update(boardgame_id: boardgame.id, failed_identification: false, is_boardgame: true)
        redirect_to admin_listing_path(@listing), notice: "Listing has been linked to #{boardgame.title}."
      else
        redirect_to admin_listing_path(@listing), alert: "Boardgame not found on Database."
      end
    end

    def unidentify
      @listing = Listing.find(params[:id])
      @listing.update(boardgame_id: nil, failed_identification: true)
      redirect_to admin_listing_path(@listing), notice: "Listing has been unlinked."
    end
  end
end
