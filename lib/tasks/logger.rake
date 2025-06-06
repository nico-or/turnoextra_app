desc "switch rails logger to stdout"
task verbose: [ :environment ] do
  Rails.logger = Logger.new(STDOUT)
end

desc "switch rails logger log level to debug"
task debug: [ :environment, :verbose ] do
  Rails.logger.level = Logger::DEBUG
end

desc "switch rails logger log level to info"
task info: [ :environment, :verbose ] do
  Rails.logger.level = Logger::INFO
end
