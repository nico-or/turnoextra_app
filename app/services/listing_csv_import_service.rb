class ListingCsvImportService < ApplicationService
  BATCH_SIZE = 100

  attr_reader :file

  def initialize(file)
    @file = file
  end

  def call
    table = CSV.table(file, converters: nil)

    rows = table.reject { |row| row[:stock] == "false" }


    stores_by_url = find_or_create_stores(rows)
    listings_by_url = find_or_create_listings(rows, stores_by_url)

    prices_params = rows.map do |row|
      listing = listings_by_url[row[:url]]
      {
        listing_id: listing.id,
        amount: row[:price].to_i,
        date: row[:date]
      }
    end

    Price.insert_all(prices_params)
  end

  private

  def find_or_create_stores(rows)
    row_urls = rows.map { |row| URI.parse(row[:url]).origin }.uniq

    existing_urls = Store.where(url: row_urls).pluck(:url)
    missing_urls = row_urls - existing_urls

    stores_params = missing_urls.map do |url|
      { url: url, name: URI.parse(url).hostname }
    end
    Store.insert_all(stores_params) if missing_urls.any?

    Store.where(url: row_urls).index_by(&:url)
  end

  def find_or_create_listings(rows, stores_by_url)
    listings_params = rows.map do |row|
      listing_url = row[:url]
      store = stores_by_url[URI.parse(listing_url).origin]
      {
        url: listing_url,
        title: row[:title],
        store_id: store.id
      }
    end

    Listing.upsert_all(listings_params,
    update_only: [ :title ],
    unique_by: [ :url ])

    Listing.where(url: rows.map { |row| row[:url] }).index_by(&:url)
  end
end
