source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.1"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

# Use PostgreSQL as the database for Active Record
gem "pg"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache and Active Job
gem "solid_cache"
gem "solid_queue"

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

gem "httparty", "~> 0.22.0"

gem "bcrypt", "~> 3.1"

gem "csv", "~> 3.3"

gem "dotenv", "~> 3.1"


gem "unicode", "~> 0.4.4"

group :test do
  gem "webmock", "~> 3.25"
  gem "simplecov", "~> 0.22.0"
end

gem "pagy", "~> 9.3"

gem "importmap-rails", "~> 2.1"

gem "chartkick", "~> 5.2"

gem "rubyzip", "~> 2.4", require: "zip"

gem "mechanize", "~> 2.14"

gem "rails-i18n", "~> 8.0"

gem "meta-tags", "~> 2.22"

gem "cssbundling-rails", "~> 1.4"

gem "mission_control-jobs", "~> 1.1"
