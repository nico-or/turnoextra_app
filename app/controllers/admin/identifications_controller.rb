module Admin
  class IdentificationsController < AdminController
    def index
      @listings = Listing.boardgames_only.failed_identification
        .group("LOWER(title)")
        .select(
          "LOWER(title) AS lower_title",
          "COUNT(*) AS listings_count"
        )
        .order(
          "listings_count DESC",
          "LOWER(title) ASC"
        )
    end

    def new
      @listings = Listing.boardgames_only.failed_identification.order(:id)

      if params[:query].present?
        @listings = @listings.with_title_like(params[:query])
      end

      if params[:title].present?
        @listings = @listings.where("LOWER(title) = LOWER(?)", params[:title])
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
      count = Listing.where(id: params[:listing_ids]).update_all(is_boardgame: false)
      flash[:notice] = "Updated #{count} Listings."
      redirect_to admin_identifications_path
    end
  end
end
