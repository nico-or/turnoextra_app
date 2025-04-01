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
end
