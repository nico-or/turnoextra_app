module Identification
  class ListingIdentifier
    attr_reader :search_method_class, :threshold, :logger, :listing_updater_class

    def initialize(
      search_method_class:,
      threshold: 0.8,
      logger: default_logger,
      listing_updater_class: ListingUpdater
    )
      @search_method_class = search_method_class
      @threshold = threshold
      @logger = ActiveSupport::TaggedLogging.new(logger)
      @listing_updater_class = listing_updater_class
    end

    def identify!(listing)
      return if already_failed?(listing)

      results = search_results(listing)
      listing_updater = listing_updater_class.new(listing, logger: logger)

      return listing_updater.fail_all!("no results", search_method_class) if results.empty?

      ranked_results = rank_results(results)

      return listing_updater.fail_all!("no results above threshold", search_method_class) if ranked_results.empty?

      top_result = ranked_results.first
      boardgame = Boardgame.find_by(bgg_id: top_result.bgg_id)

      return listing_updater.fail_all!("no boardgame found for BGG ID: #{top_result.bgg_id}", search_method_class) if boardgame.nil?

      listing_updater.identify_all!(boardgame)
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
      search_method_class.call(query)
    end

    def rank_results(results)
      SearchMethod::SearchResultRanker.new(results).call
        .reject { |result| result.similarity < threshold }
    end

    def default_logger
      Logger.new(STDOUT)
    end
  end
end
