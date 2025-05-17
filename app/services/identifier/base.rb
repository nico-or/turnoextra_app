module Identifier
  class Base
    def initialize(listings)
      @listings = listings
    end

    def call
      @listings.find_each do |listing|
        query = listing.normalized_title
        boardgame = find_boardgame(query)

        if boardgame.nil?
          count = listings_with_same_title(query).update_all(failed_flag => true)
          log_failure(count, listing)
          next
        end

        count = records_to_update(listing, boardgame).update_all({ boardgame_id: boardgame.id }.merge(failure_flags))
        log_success(count, listing, boardgame)
      end
    end

    private

    def find_boardgame(query)
      search_results = search_method_class.new(query).call
      ranked_search_results = SearchResultsRankerService.new(query, search_results).call
      Boardgame.find_by(bgg_id: ranked_search_results.first&.bgg_id)
    end

    def listings_with_same_title(string)
      Listing.unidentified.where("LOWER(normalized_title) = LOWER(?)", string)
    end

    def records_to_update(listing, boardgame)
      listing_siblings = Listing.unidentified.where("LOWER(normalized_title) = LOWER(?)", listing.normalized_title)
      boardgame_siblings = Listing.unidentified.where("LOWER(normalized_title) = LOWER(?)", boardgame.normalized_title)
      listing_siblings.or(boardgame_siblings)
    end

    def log_failure(count, listing)
      Rails.logger.debug(@progname) { "Failed to identify #{count}x[#{listing.normalized_title}]" }
    end

    def log_success(count, listing, boardgame)
      Rails.logger.info(@progname) { "Identified #{count}x[#{listing.normalized_title}] records as [#{boardgame.normalized_title}]." }
    end

    def progname
      self.class.name
    end

    def failure_flags
      {
        failed_local_identification: false,
        failed_bgg_api_identification: false
      }
    end

    # Methods subclasses must implement
    def failed_flag
      raise NotImplementedError
    end

    def other_failed_flag
      raise NotImplementedError
    end

    def search_method_class
      raise NotImplementedError
    end
  end
end
