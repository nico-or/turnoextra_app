module Identifier
  class ListingIdentifier
    attr_reader :search_method_class, :threshold, :logger

    def initialize(search_method_class:, threshold: 0.8, logger: default_logger)
      @search_method_class = search_method_class
      @threshold = threshold
      @logger = ActiveSupport::TaggedLogging.new(logger)
    end

    def identify!(listing)
      return if already_failed?(listing)

      results = search_results(listing)

      return fail_all_siblings!(listing, "no results") if results.empty?

      ranked_results = rank_results(results)

      return fail_all_siblings!(listing, "no results above threshold") if ranked_results.empty?

      top_result = ranked_results.first
      boardgame = Boardgame.find_by(bgg_id: top_result.bgg_id)

      return fail_all_siblings(listing, "no boardgame found for BGG ID: #{top_result.bgg_id}") if boardgame.nil?

      identify_all_siblings(listing, boardgame)
      listing
    end

    private

    def already_failed?(listing)
      failed = IdentificationFailure.exists?(identifiable: listing, search_method: search_method_class.name)
      log_info("Already failed to identify [#{listing.title}] with [#{search_method_class.name}]") if failed
      failed
    end

    def build_query(listing)
      Text::Normalization.normalize_title(listing.title)
    end

    def search_results(listing)
      query = build_query(listing)
      search_method_class.new(query).call
    end

    def rank_results(results)
      SearchMethod::SearchResultRanker.new(results).call
        .reject { |result| result.similarity < threshold }
    end

    def listings_with_same_title(listing)
      Listing.boardgames_only.unidentified
        .where("LOWER(title) = LOWER(?)", listing.title)
    end

    def identify_all_siblings(listing, boardgame)
      count = listings_with_same_title(listing).update_all(boardgame_id: boardgame.id)

      log_info("#{count}x [#{listing.title}] => [#{boardgame.title}]")
    end

    def fail_all_siblings!(listing, reason)
      siblings = listings_with_same_title(listing)
      siblings.each { |l| register_failure(l, reason) }
      count = siblings.count
      log_error("#{count}x [#{listing.title}] failed to identify: #{reason}")
      nil
    end

    def register_failure(listing, reason)
      IdentificationFailure.create!(
        identifiable: listing,
        search_method: search_method_class,
        reason: reason
      )
    end

    def log_error(message)
      logger.tagged("ListingIdentifier") { logger.error message }
    end

    def log_info(message)
      logger.tagged("ListingIdentifier") { logger.info message }
    end

    def default_logger
      Logger.new(STDOUT)
    end
  end
end
