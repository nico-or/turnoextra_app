namespace :boardgame do
  ## Seed BGG boardgame data
  # source: https://boardgamegeek.com/data_dumps/bg_ranks
  # about: https://boardgamegeek.com/wiki/page/BGG_XML_API2#toc1
  desc "Updates Boardgames with daily BGG ranks csv dump"
  task update_ranks: [ :environment, "bgg:download_ranks" ] do
    Rails.logger.info "Updating boardgame ranks from CSV file"
    filepath = Bgg::RankCsvDownloader::OUTPUT_PATH
    Bgg::RankUpdater.call(filepath)
  end

  namespace :update_metadata do
    desc "update boardgames with listings"
    task with_listings: :environment do
      boardgames = Boardgame.has_listings
      Bgg::BoardgameMetadataUpdater.new(boardgames).update!
    end

    desc "update boardgames with listings and missing images"
    task missing_images: :environment do
      boardgames = Boardgame.has_listings.where(image_url: [ nil, "" ])
      Bgg::BoardgameMetadataUpdater.new(boardgames).update!
    end
  end

  desc "Updates normalized title field in Boardgames records"
  task update_normalized_titles: :environment do
    Rails.logger.info "Updating normalized_title for #{Boardgame.count} Boardgame records"
    count = 0

    Boardgame.find_each do |boardgame|
      normalized_title = Text::Normalization.normalize_string(boardgame.title)
      boardgame.update_columns(normalized_title: normalized_title)

      count += 1
      Rails.logger.info "Processed #{count} Boardgames" if (count % 1_000).zero?
    end
  end
end
