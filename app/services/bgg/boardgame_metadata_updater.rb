module Bgg
  class BoardgameMetadataUpdater
    def initialize(boardgame_records_collection, client: Bgg::Client.new, logger: Rails.logger)
      @boardgames = boardgame_records_collection
      @api_client = client
      @logger = logger
    end

    def update!
      api_limit = Bgg::Client::MAX_ID_COUNT_PER_REQUEST

      @boardgames.find_in_batches(batch_size: api_limit) do |batch|
        bgg_ids = batch.pluck(:bgg_id)
        @logger.info "Fetching data for BGG IDs: [ #{bgg_ids.join(', ')} ]"

        boardgame_responses = @api_client.boardgame(*bgg_ids)

        boardgame_responses.each do |boardgame_response|
          @logger.info "Updating metadata for BGG ID: #{boardgame_response.bgg_id} - #{boardgame_response.title}"
          ThingCreator.new(boardgame_response).create!
        end
      ensure
        sleep 5
      end
    end
  end
end
