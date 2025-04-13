class ListingCsvImportService < ApplicationService
  BATCH_SIZE = 100

  attr_reader :file

  def initialize(file)
    @file = file
  end

  def call
    table = CSV.table(file, converters: nil)

    rows_per_store = table.reject { |row| row[:stock] == "false" }
                          .group_by { |row| URI.parse(row[:url]).origin }

    rows_per_store.each do |store_url, rows|
      store = create_store(store_url)

      rows.each do |row|
        listing = create_listing(store, row)
        _price = create_price(listing, row)
      end
    end
  end

  private

  def create_store(store_url)
    Store.find_or_create_by(url: store_url) do |store|
      store.name = URI.parse(store_url).hostname
    end
  end

  def create_listing(store, row)
    Listing.find_or_create_by(url: row[:url]) do |l|
      l.store = store
      l.title = row[:title]
    end
  end

  def create_price(listing, row)
    listing.prices.find_or_create_by!(date: row[:date]) do |price|
      price.amount = row[:price]
    end
  end
end
