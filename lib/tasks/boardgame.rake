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
end
