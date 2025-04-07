class ListingCsvImportService < ApplicationService
  BATCH_SIZE = 100

  attr_reader :file

  def initialize(file)
    @file = file
  end

  def call
    csv_options = { headers: true, header_converters: :symbol }
    CSV.foreach(file, **csv_options)
       .reject { |row| row[:stock] == "false" }
       .each_slice(BATCH_SIZE) do |rows|
      ActiveRecord::Base.transaction do
        rows.each do |row|
          store = create_store(row)
          listing = create_listing(store, row)
          create_price(listing, row)
        end
      end
    end
  end

  private

  def create_store(row)
    store_uri = URI.parse(row[:url])
    store_name = store_uri.hostname
    store_url = store_uri.origin
    Store.find_or_create_by!(url: store_url) do |store|
      store.name = store_name
    end
  end

  def create_listing(store, row)
    listing_title =  row[:title]
    listing_url =  row[:url]
    store.listings.find_or_create_by!(url: listing_url) do |listing|
      listing.title = listing_title
    end
  end

  def create_price(listing, row)
    price_amount = row[:price]
    price_date = row[:date]
    listing.prices.find_or_create_by!(date: price_date) do |price|
      price.amount = price_amount
    end
  end
end
