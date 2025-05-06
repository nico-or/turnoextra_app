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
  end
end
