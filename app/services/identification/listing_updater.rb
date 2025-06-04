module Identification
  class ListingUpdater
    def initialize(listing, logger: default_logger)
      @listing = listing
      @logger = ActiveSupport::TaggedLogging.new(logger)
    end

    def identify_all!(boardgame)
      count = listings_to_update.update_all(boardgame_id: boardgame.id)
      log_info("#{count}x [#{@listing.title}] => [#{boardgame.title}]")
    end

    def fail_all!(reason, search_method_class)
      listings_to_update.each do |listing|
        listing.identification_failures.create!(
          search_method: search_method_class,
          reason: reason
        )
      end
      log_error("#{listings_to_update.count}x [#{@listing.title}] failed to identify: #{reason}")
    end

    private

    def listings_to_update
      Listing.boardgames_only.unidentified
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
