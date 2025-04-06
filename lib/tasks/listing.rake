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
    # TODO: create 2 identifiers, one for local Boardgame database, other for API
    # create here to make use of the internal cache
    listings = Listing.where(failed_identification: false)
                      .where(is_boardgame: true)
                      .where(boardgame: nil)

    listings.find_each do |listing|
      ListingIdentificationService.call(listing)
      sleep Random.rand(2..4)
    end
  end
end
