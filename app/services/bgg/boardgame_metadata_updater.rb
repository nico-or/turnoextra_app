module Bgg
  class BoardgameMetadataUpdater
    attr_reader :bgg_ids, :client

    def initialize(*bgg_ids, client: Bgg::Client.new)
      @bgg_ids = [ bgg_ids ].flatten
      @client = client

      validate_bgg_ids!
    end

    def call
      boardgame_results.filter_map do |boardgame_result|
        boardgame_record = boardgame_records.find_by(bgg_id: boardgame_result.bgg_id)
        next unless boardgame_record

        update_boardgame_details(boardgame_record, boardgame_result)
        update_boardgame_names(boardgame_record, boardgame_result)
        boardgame_record
      end
    end

    private

    def validate_bgg_ids!
      max_id_count = Bgg::Client::MAX_ID_COUNT_PER_REQUEST
      raise ArgumentError, "bgg_ids must be an array of integers" unless bgg_ids.is_a?(Array) && bgg_ids.all? { |id| id.is_a?(Integer) }
      raise ArgumentError, "bgg_ids must not exceed #{max_id_count}" if bgg_ids.count > max_id_count # TODO: Move this value to a constant in the Bgg module
    end

    def boardgame_results
      client.boardgame(*bgg_ids)
    end

    def boardgame_records
      ::Boardgame.where(bgg_id: bgg_ids)
    end

    def update_boardgame_details(boardgame_record, boardgame_result)
      boardgame_record.update(
        bgg_id: boardgame_result.bgg_id,
        year: boardgame_result.year,
        title: boardgame_result.title,
        image_url: boardgame_result.image_url,
        thumbnail_url: boardgame_result.thumbnail_url
      )
    end

    def update_boardgame_names(boardgame_record, boardgame_result)
      boardgame_names_params = boardgame_result.titles.map do |title|
        { value: title }
      end
      boardgame_record.boardgame_names.insert_all(boardgame_names_params)
    end
  end
end
