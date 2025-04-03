require "nokogiri"

namespace :bgg do
  desc "remove unwanted tags from BGG xml responses"
  task :remove_xml_tags do
    UNWANTED_TAGS = [
      "boardgameaccessory",
      "boardgameartist",
      "boardgamecategory",
      "boardgamecompilation",
      "boardgamedesigner",
      "boardgameexpansion",
      "boardgamefamily",
      "boardgamegraphicdesigner",
      "boardgamehonor",
      "boardgameimplementation",
      "boardgameinsertdesigner",
      "boardgameintegration",
      "boardgamemechanic",
      "boardgamepodcastepisode",
      "boardgamepublisher",
      "boardgamesolodesigner",
      "boardgamesubdomain",
      "boardgameversion",
      "cardset",
      "videogamebg"
    ]

    file_glob = "test/fixtures/files/bgg/api/v1/*.xml"

    Pathname.glob(file_glob).each do |filepath|
      parsed = Nokogiri::XML(File.read(filepath))
      UNWANTED_TAGS.each do |tag|
        # remove tags
        parsed.xpath("//#{tag}").each(&:remove)

        # remove left-behind white space
        parsed.xpath("//text").each { it.remove if it.strip.blank? }

        # write new_file
        File.open(filepath, "w") { it.write parsed.to_xml(encoding: "utf-8") }
      end
    end
  end

  ## Seed BGG boardgame data
  # source: https://boardgamegeek.com/data_dumps/bg_ranks
  # about: https://boardgamegeek.com/wiki/page/BGG_XML_API2#toc1
  desc "Updates Boardgames with daily BGG ranks csv dump"
  task update_ranks: :environment do
    # TODO: add task for downloading the csv before
    filepath = "db/seeds/boardgames_ranks.csv"
    BggRankUpdateService.call(filepath)
  end

  desc "Uploads a scrapped Listing CSV"
  task upload_listings: :environment do
    filepaths = Pathname.glob("db/seeds/listings/*_spider.csv")
    filepaths.each do |filepath|
      Rails.logger.info "Uploading #{filepath} data..."
      ListingCsvImportService.call(filepath)
    end
  end

  desc "Identifies all Listings without a boardgame_id"
  task identify_listings: :environment do
    # TODO: turn this into a service object
    # TODO: create 2 identifiers, one for local Boardgame database, other for API
    # create here to make use of the internal cache
    identifier = Bgg::Identifier.new

    listings = Listing.select(:id, :title)
                      .where(boardgame: nil)
                      .order(:title)
                      .limit(100)

    # FIXME: can't use sorted #find_each without a primary_key or unique_index column!
    # listings.find_each(cursor: :title) do |listing|
    listings.each do |listing|
      Rails.logger.info "Identifing: #{listing.inspect}"
      results = identifier.identify!(listing.title)

      if results.empty?
        Rails.logger.info "Failed to identify #{listing.inspect}"
      else
        boardgame = Boardgame.find_by(bgg_id: results.first.id)
        Rails.logger.info "Identified #{listing.inspect} as #{boardgame.inspect}"
        # TODO: fetch and update every listing with the same
        Listing.update(listing.id, boardgame: boardgame)
      end
      sleep Random.rand(1..4) # Don't flood the api with requests
    end
  end
end
