require "nokogiri"

namespace :boardgame do
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
