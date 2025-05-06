module Admin
  class IdentificationsController < AdminController
    def index
      @listings = Listing.where(failed_identification: true)
                         .where(boardgame: nil)
                         .where(is_boardgame: true)
                         .group("LOWER(title)")
                         .select("LOWER(title) AS lower_title, COUNT(*) AS listings_count")
                         .order("listings_count DESC")
    end

    def new
      @listings = Listing.where(failed_identification: true)
                         .where(boardgame: nil)
                         .where(is_boardgame: true)
                         .where("lower(title) = ?", params[:title])

      if params[:bgg_query].present?
        @results = Bgg::Versions::XmlV1.search(params[:bgg_query])
      else
        @results = []
      end
    end

    def create
      boardgame = Boardgame.find_by(bgg_id: params[:bgg_id])

      if boardgame
        count = Listing.where(id: params[:listing_ids])
                       .update_all({ boardgame_id: boardgame.id, failed_identification: false })

        flash[:notice] = "Updated #{count} Listings."
      else
        flash[:alert] = "Did not find a Boardgame with BGG ID = #{params[:bgg_id]}."
      end
      redirect_to admin_identifications_path
    end
  end
end
