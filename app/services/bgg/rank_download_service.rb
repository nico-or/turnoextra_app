class Bgg::RankDownloadService
  LOGIN_URL = "https://boardgamegeek.com/login/api/v1"
  RANKS_URL = "https://boardgamegeek.com/data_dumps/bg_ranks"
  OUTPUT_PATH = Rails.root.join("db", "seeds", "boardgames_ranks.csv")

  def initialize
    @username = ENV.fetch("BGG_USERNAME")
    @password = ENV.fetch("BGG_PASSWORD")
    @agent = Mechanize.new
  end

  def call
    unless needs_download?
      log("No need to download ranks.")
      return
    end

    log("Logging in to BGG...")
    login

    log("Resetting deleted cookies...")
    reset_cookies

    log("Fetching ranks page...")
    @agent.get(RANKS_URL)

    log("Downloading and saving CSV...")
    download_and_save_csv

    log("Done!")
  end

  private

  def needs_download?
    !output_exists? || output_outdated?
  end

  def output_exists?
    File.exist?(OUTPUT_PATH)
  end

  def output_outdated?
    OUTPUT_PATH.mtime.to_date < Date.today
  end

  def login
    credentials = { username: @username, password: @password }
    @agent.post(LOGIN_URL, { credentials: credentials })
  end

  def reset_cookies
    { "bggusername" => @username, "bggpassword" => @password }.each do |k, v|
      cookie = Mechanize::Cookie.new(k, v).tap do |c|
        c.domain = "boardgamegeek.com"
        c.path = "/"
      end
      @agent.cookie_jar.add(cookie)
    end
  end

  def download_and_save_csv
    log("Downloading ZIP file...")
    data_link = @agent.page.link_with(text: /download/i)
    mechanize_file = data_link.click

    Tempfile.create(binmode: true) do |tmp_file|
      tmp_file.write(mechanize_file.body)
      tmp_file.flush

      Zip::File.open(tmp_file.path) do |zip|
        csv_entry = zip.entries.first

        log("Saving CSV to #{OUTPUT_PATH}...")
        File.open(OUTPUT_PATH, "wb") do |file|
          file.write(csv_entry.get_input_stream.read)
        end
      end
    end
  end

  def log(message)
    Rails.logger.info(message)
  end
end
