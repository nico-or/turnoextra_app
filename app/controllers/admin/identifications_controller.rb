module Admin
  class IdentificationsController < AdminController
    def index
      listings = Listing.requires_identification.order("LOWER(title)")

      @pagy, @listings = pagy(listings)
    end

    def new
      if params[:query].present?
        @listings = Listing.requires_identification.order(:id).where("similarity(title, ?) > ?", params[:query], 0.6)
      else
        @listings = []
      end

      if params[:bgg_query].present?
        query = params[:bgg_query]
        client = Bgg::Client.new

        results = client.search(query)
        ranked_results = results.sort_by { |result| -Text::Trigram.similarity(query, result.title) }

        @boardgames = ranked_results.uniq(&:bgg_id).filter_map do |result|
          boardgame = Boardgame.find_by(bgg_id: result.bgg_id)
          next unless boardgame
          [ result, boardgame ]
        end
      else
        @boardgames = []
      end
    end

    def create
      boardgame = Boardgame.find_by(bgg_id: params[:bgg_id])

      if boardgame
        count = Listing.where(id: params[:listing_ids])
                       .update_all(boardgame_id: boardgame.id)

        flash[:notice] = "Updated #{count} Listings."
      else
        flash[:alert] = "Did not find a Boardgame with BGG ID = #{params[:bgg_id]}."
      end
      redirect_to admin_identifications_path
    end

    def toggle_is_boardgame
      count = Listing.where(id: params[:listing_ids]).update_all(is_boardgame: false, boardgame_id: nil)
      flash[:notice] = "Updated #{count} Listings."
      redirect_to admin_identifications_path
    end
  end
end
