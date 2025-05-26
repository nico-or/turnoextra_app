module Admin
  class ListingsController < AdminController
    def index
      @pagy, @listings = pagy(Listing.includes(:store).all.order(title: :asc), limit: 10)
    end

    def show
      @listing = Listing.find(params[:id])

      if params[:bgg_query].present?
        query = params[:bgg_query]
        client = Bgg::Client.new

        results = client.search(query)
        boardgames = Boardgame.where(bgg_id: results.map(&:bgg_id))
                              .sort_by { |bg| -Text::Trigram.similarity(query, bg.title) }
      end
      @boardgames = boardgames || []
    end

    def identify
      @listing = Listing.find(params[:id])
      boardgame = Boardgame.find_by(bgg_id: params[:bgg_id])
      if boardgame.present?
        @listing.update(boardgame_id: boardgame.id, is_boardgame: true)
        @listing.set_failed_identification_flags(false)
        redirect_to admin_listing_path(@listing), notice: "Listing has been linked to #{boardgame.title}."
      else
        redirect_to admin_listing_path(@listing), alert: "Boardgame not found on Database."
      end
    end

    def unidentify
      @listing = Listing.find(params[:id])
      @listing.update(boardgame_id: nil)
      @listing.set_failed_identification_flags(true)
      redirect_to admin_listing_path(@listing), notice: "Listing has been unlinked."
    end
  end
end
