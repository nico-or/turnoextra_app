class UploadsController < ApplicationController
  before_action :set_files, only: [ :create ]
  def new
  end

  def create
    # TODO: make service objects
    # TODO: make background jobs

    require "csv"

    @files.each do |file|
      CSV.foreach(file.path, headers: true, header_converters: :symbol)
         .reject { |row| row[:stock] == "false" }
         .each_slice(50) do |rows|
        ActiveRecord::Base.transaction do
          rows.each do |row|
            store = create_store(row)
            listing = create_listing(store, row)
            create_price(listing, row)
          end
        end
      end
    end

    flash.notice = "upload successful."
    render :new
  end

  private

  def create_store(row)
    store_uri = URI.parse(row[:url])
    store_params = { name: store_uri.hostname, url: store_uri.origin }
    Store.find_or_create_by!(store_params)
  end

  def create_listing(store, row)
    listing_params = { title: row[:title], url: row[:url] }
    store.listings.find_or_create_by!(listing_params)
  end

  def create_price(listing, row)
    price_params ={ price: row[:price], date: row[:date] }
    listing.prices.find_or_create_by!(price_params)
  end

  def upload_params
    params.expect(files: [])
  end

  def set_files
    @files = upload_params
    unless @files.present? && !@files.empty?
      redirect_to new_upload_path, status: :unprocessable_entity
    end
  end
end
