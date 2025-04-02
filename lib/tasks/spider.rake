namespace :spider do
  desc "import tanaki csv output data"
  task import: :environment do
    file_glob = "db/seeds/*_spider.csv"

    Pathname.glob(file_glob).each do |filepath|
      CsvUploaderService.call(filepath)
    end
  end
end
