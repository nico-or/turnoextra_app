namespace :boardgame do
  ## Seed BGG boardgame data
  # source: https://boardgamegeek.com/data_dumps/bg_ranks
  # about: https://boardgamegeek.com/wiki/page/BGG_XML_API2#toc1
  desc "Updates Boardgames with daily BGG ranks csv dump"
  task update_ranks: [ :environment, "bgg:download_ranks" ] do
    Rails.logger.info "Updating boardgame ranks from CSV file"
    filepath = Bgg::RankDownloadService::OUTPUT_PATH
    Bgg::RankUpdateService.call(filepath)
  end

  desc "Add images urls to boardgames"
  task add_images: :environment do
    BATCH_SIZE = 20 # API limit
    client = Bgg::Client.new

    boardgames = Boardgame.has_listings.without_images

    Rails.logger.info "Found #{boardgames.count} boardgames with listings but without images"

    boardgames.find_in_batches(batch_size: BATCH_SIZE) do |batch|
      ids = batch.pluck(:bgg_id)
      Rails.logger.info "Fetching data for #{ids.join(", ")}"

      search_results = client.boardgame(*ids)
      sleep(10)

      search_results.each do |search_result|
        boardgame = batch.find { |boardgame| boardgame.bgg_id == search_result.bgg_id }
        boardgame.update(
          image_url: search_result.image_url,
          thumbnail_url: search_result.thumbnail_url
        )

        if  boardgame.save
          Rails.logger.info "Updated #{boardgame.title}"
        else
          Rails.logger.error "Failed to update #{boardgame.title}: #{boardgame.errors.full_messages.join(", ")}"
        end
      end
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
