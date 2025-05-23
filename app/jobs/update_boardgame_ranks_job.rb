class UpdateBoardgameRanksJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Bgg::RankCsvDownloader.new.call
    filepath = Bgg::RankCsvDownloader::OUTPUT_PATH
    Bgg::RankUpdateService.call(filepath)
  end
end
