namespace :bgg do
  desc "Download daily BGG ranks CSV dump"
  task download_ranks: [ :environment, :info ] do
    Bgg::RankCsvDownloader.new.call
  end
end
