# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

## Seed BGG boardgame data
# source: https://boardgamegeek.com/data_dumps/bg_ranks
# about: https://boardgamegeek.com/wiki/page/BGG_XML_API2#toc1

require 'csv'

filepath = 'db/seeds/boardgames_ranks.csv'
options = { headers: true }

COUNT_LIMIT = 1_000 if Rails.env.development?
BATCH_SIZE = 1_000

Boardgame.transaction do
  csv_enum = CSV.foreach(filepath, **options)
  csv_enum = csv_enum.first(COUNT_LIMIT) if COUNT_LIMIT

  csv_enum.each_slice(BATCH_SIZE)  do |rows|
    games = rows.map do |row|
      { bgg_id: row['id'].to_i, title: row['name'] }
    end

    # ActiveRecord::Relation#insert_all skips model validations!
    # Ensure that the CSV data is valid for mass import
    Boardgame.insert_all(games)
  end
end
