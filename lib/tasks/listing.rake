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

  namespace :identify do
    desc "Identifies all Listings without a boardgame_id using local database"
    task database: :environment do
      listings = Listing.boardgames_only.unidentified
        .where(failed_local_identification: false)
        .where(failed_bgg_api_identification: false)
      Rails.logger.info "Identifying #{listings.count} listings using local database"
      Identifier::DatabaseIdentifier.new(listings).call
    end

    desc "Identifies all Listings without a boardgame_id using BGG API"
    task bgg_api: :environment do
      listings = Listing.boardgames_only.unidentified
        .where(failed_local_identification: true)
      Rails.logger.info "Identifying #{listings.count} listings using BGG API"
      Identifier::BggApiIdentifier.new(listings).call
    end
  end

  desc "Updates normalized title field in Listings records"
  task update_normalized_titles: :environment do
    Rails.logger.info "Updating normalized_title for #{Listing.count} Listing records"
    count = 0

    Listing.find_each do |listing|
      normalized_title = Text::Normalization.normalize_title(listing.title)
      listing.update_columns(normalized_title: normalized_title)

      count += 1
      Rails.logger.info "Processed #{count} Listings" if (count % 1_000).zero?
    end
  end
end
