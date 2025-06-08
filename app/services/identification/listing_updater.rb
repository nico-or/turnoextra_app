module Identification
  class ListingUpdater
    def initialize(listing, logger: default_logger)
      @listing = listing
      @logger = ActiveSupport::TaggedLogging.new(logger)
    end

    def identify_all!(boardgame)
      count = listings_to_update.update_all(boardgame_id: boardgame.id)
      log_info("#{count}x [#{@listing.title}] => [#{boardgame.title}]")
      count
    end

    def fail_all!(reason, search_method_class)
      failure_params = listings_to_update.map do |listing|
        {
          identifiable_type: listing.class.name,
          identifiable_id: listing.id,
          search_method: search_method_class,
          reason: reason
        }
      end

      results = IdentificationFailure.insert_all(failure_params)
      log_error("#{results.count}x [#{@listing.title}] failed to identify: #{reason}")
      results.count
    end

    private

    def listings_to_update
      Listing.requires_identification
        .where("LOWER(title) = LOWER(?)", @listing.title)
    end

    def log_info(msg)
      @logger.tagged(logger_tag) { @logger.info msg }
    end

    def log_error(msg)
      @logger.tagged(logger_tag) { @logger.error msg }
    end

    def default_logger
      Logger.new(STDOUT)
    end

    def logger_tag
      self.class.name
    end
  end
end
