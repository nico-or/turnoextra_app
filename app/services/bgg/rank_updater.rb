class Bgg::RankUpdater < ApplicationService
  BATCH_SIZE = 1_000

  attr_reader :file

  def initialize(file = Bgg::RankCsvDownloader::OUTPUT_PATH, logger: Rails.logger)
    @file = file
    @logger = logger
  end

  def call
    csv_options = { headers: true, header_converters: :symbol }
    csv_enum = CSV.foreach(file, **csv_options)

    csv_enum.each_slice(BATCH_SIZE).with_index do |rows, index|
      log(format("Processing batch %4d...", index + 1))
      boardgame_params = rows.map do |row|
        {
          bgg_id: row[:id].to_i,
          title: row[:name],
          rank: row[:rank],
          year: row[:yearpublished].to_i
        }
      end

      Boardgame.upsert_all(boardgame_params, unique_by: :bgg_id)
    end
    log("Finished processing all batches.")
  end

  private

  def log(message)
    @logger.info { "[#{self.class}] #{message}" }
  end
end
