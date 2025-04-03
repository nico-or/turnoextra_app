namespace :listing do
  desc "import tanaki csv output data"
  task import: :environment do
    file_glob = "db/seeds/listings/*_spider.csv"

    Pathname.glob(file_glob).each do |filepath|
      Rails.logger.info "Importing: #{filepath}"
      ListingCsvImportService.call(filepath)
    end
  end
end
