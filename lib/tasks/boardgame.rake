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

  desc "Add images urls to boardgames"
  task add_images: :environment do
    BATCH_SIZE = 20 # API limit

    boardgames = Boardgame.has_listings.without_images

    Rails.logger.info "Found #{boardgames.count} boardgames with listings but without images"

    boardgames.find_in_batches(batch_size: BATCH_SIZE) do |batch|
      ids = batch.pluck(:bgg_id)
      Rails.logger.info "Fetching data for #{ids.join(", ")}"

      boardgame_responses = Bgg::Versions::XmlV1.boardgame(*ids)
      sleep(10) # respect API rate limit

      boardgame_responses.each do |boardgame_response|
        boardgame = batch.find { |boardgame| boardgame.bgg_id == boardgame_response.id }
        boardgame.update(
          image_url: boardgame_response.image_url,
          thumbnail_url: boardgame_response.thumbnail_url
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
  task update_reference_price: :environment do
    reference_period = (Price.latest_update_date - 2.weeks..Price.latest_update_date)

    boardgames = Boardgame.has_listings
    Rails.logger.info "Updating reference price for #{boardgames.count} boardgames"

    boardgames.find_each do |boardgame|
      Rails.logger.info "Updating reference price for #{boardgame.title}"
      prices = boardgame.prices.where(date: reference_period).order(:amount).pluck(:amount)
      next if prices.empty?

      # Find the median price
      case prices.length % 2
      when 1
        boardgame.reference_price = prices[prices.length / 2]
      when 0
        left_price = prices[prices.length / 2 - 1]
        right_price = prices[prices.length / 2]
        boardgame.reference_price = (left_price + right_price) / 2.0
      end

      boardgame.save
    end

    Rails.logger.info "Finished updating reference price for boardgames"
  end
end
