namespace :listing do
  desc "import tanaki csv output data"
  task import: :environment do
    file_glob = "db/seeds/listings/*_spider.csv"
    filepaths = Pathname.glob(file_glob)
    filepaths.each do |filepath|
      Rails.logger.info "Importing: #{filepath}"
      ListingCsvImportService.call(filepath)
    end
  end

  desc "Identifies all Listings without a boardgame_id"
  task identify: :environment do
    listings = Listing.boardgames_only.unidentified
      .where(failed_local_identification: false)
      .where(failed_bgg_api_identification: false)

    Rails.logger.info "Identifying #{listings.count} listings using local database"
    Identifier::DatabaseIdentifier.new(listings).call

    listings = Listing.boardgames_only.unidentified
      .where(failed_local_identification: true)

    Rails.logger.info "Identifying #{listings.count} listings using BGG API"
    Identifier::BggApiIdentifier.new(listings).call

    ensure
    Rake::Task["boardgame:add_images"].invoke
    Rake::Task["boardgame:update_prices"].invoke
  end
end
