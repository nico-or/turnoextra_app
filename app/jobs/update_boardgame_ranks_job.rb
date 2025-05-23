class UpdateBoardgameRanksJob < ApplicationJob
  queue_as :default

  def perform(*args)
    filepath = Bgg::RankCsvDownloader.new.call
    Bgg::RankUpdater.call(filepath)
  end
end
