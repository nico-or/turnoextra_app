class UpdateBoardgameRanksJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Bgg::RankDownloadService.new.call
    filepath = Bgg::RankDownloadService::OUTPUT_PATH
    Bgg::RankUpdateService.call(filepath)
  end
end
