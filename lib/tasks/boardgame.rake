namespace :boardgame do
  ## Seed BGG boardgame data
  # source: https://boardgamegeek.com/data_dumps/bg_ranks
  # about: https://boardgamegeek.com/wiki/page/BGG_XML_API2#toc1
  desc "Updates Boardgames with daily BGG ranks csv dump"
  task update_ranks: :environment do
    # TODO: add task for downloading the csv before
    filepath = "db/seeds/boardgames_ranks.csv"
    BggRankUpdateService.call(filepath)
  end
end
