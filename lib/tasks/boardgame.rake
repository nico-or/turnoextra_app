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

  desc "Add images urls to boardgames"
  task update_metadata: :environment do
    api_batch_limit = Bgg::Client::MAX_ID_COUNT_PER_REQUEST
    client = Bgg::Client.new

    # TODO: prevent updating recently updated boardgames
    # TODO: prevent updating boardgames with no listings (?)
    # TODO: prevent updating out of stock boardgames (?)
    boardgames = Boardgame.has_listings

    Rails.logger.info "Fetching BGG data for #{boardgames.count} boardgames"

    boardgames.find_in_batches(batch_size: api_batch_limit) do |batch|
      bgg_ids = batch.pluck(:bgg_id)

      Rails.logger.info "Fetching BGG data for #{bgg_ids.join(', ')}"

      updater_service = Bgg::BoardgameMetadataUpdater.new(bgg_ids, client: client)
      updated_boardgame_records = updater_service.call

      Rails.logger.info "Updated #{updated_boardgame_records.size} boardgames" if updated_boardgame_records.any?
    ensure
      sleep 5 # Prevent hitting BGG API rate limit
    end
  end

  desc "Update reference price for boardgames"
  task update_prices: :environment do
    Rails.logger.info "Updating daily_boardgame_deals table"
    DailyDealsUpdateService.new.call
    Rails.logger.info "Finished updating daily_boardgame_deals table"
  end

  desc "Updates normalized title field in Boardgames records"
  task update_normalized_titles: :environment do
    Rails.logger.info "Updating normalized_title for #{Boardgame.count} Boardgame records"
    count = 0

    Boardgame.find_each do |boardgame|
      normalized_title = StringNormalizationService.normalize_string(boardgame.title)
      boardgame.update_columns(normalized_title: normalized_title)

      count += 1
      Rails.logger.info "Processed #{count} Boardgames" if (count % 1_000).zero?
    end
  end
end
