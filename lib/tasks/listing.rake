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
      search_method_class = SearchMethod::DatabaseSearch
      identifier = Identifier::ListingIdentifier.new(search_method_class:, threshold: 0.9)

      exclude_ids = IdentificationFailure.where(identifiable_type: Listing.name,  search_method: search_method_class.name).pluck(:identifiable_id)

      listings = Listing.boardgames_only.unidentified
        .where.not(id: exclude_ids)

      Rails.logger.info "Identifying #{listings.count} listings using local database"

      listings.find_each do |listing|
        identifier.identify!(listing)
      end
    end

    desc "Identifies all Listings without a boardgame_id using BGG API"
    task bgg_api: :environment do
      search_method_class = SearchMethod::BggApiSearch
      identifier = Identifier::ListingIdentifier.new(search_method_class:, threshold: 0.6)

      exclude_ids = IdentificationFailure.where(identifiable_type: Listing.name,  search_method: search_method_class.name).pluck(:identifiable_id)

      listings = Listing.boardgames_only.unidentified
        .where.not(id: exclude_ids)

      Rails.logger.info "Identifying #{listings.count} listings using BGG API"

      listings.find_each do |listing|
        identifier.identify!(listing)
      ensure
        sleep 2
      end
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
