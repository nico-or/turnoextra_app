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
  task identify: [ :environment, :info ] do
    # TODO: create 2 identifiers, one for local Boardgame database, other for API
    # create here to make use of the internal cache
    listings = Listing.boardgames_only.unidentified

    Rails.logger.info "Identifying #{listings.count} listings"

    listings.find_each.with_index do |listing, index|
      ListingIdentificationService.call(listing)
      sleep 2
    end
  ensure
    Rake::Task["boardgame:add_images"].invoke
    Rake::Task["boardgame:update_reference_price"].invoke
  end
end
