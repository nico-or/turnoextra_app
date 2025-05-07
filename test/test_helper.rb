ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"

if ENV["COVERAGE"]
  SimpleCov.start do
    enable_coverage :branch

    add_filter "test"
    add_filter "config"

    add_group "Controllers", "app/controllers"
    add_group "Helpers", "app/helpers"
    add_group "Models", "app/models"
    add_group "Presenters", "app/presenters"
    add_group "Services", "app/services"
    add_group "Views", "app/views"
    add_group "Lib/BGG", "lib/bgg"
  end
end

# Ensure SimpleCov merges results after parallel tests finish
if ENV["TEST_ENV_NUMBER"].nil? || ENV["TEST_ENV_NUMBER"].empty?
  SimpleCov.at_exit do
    SimpleCov.result.format!
  end
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    worker_count = ENV["COVERAGE"] ? 1 : :number_of_processors
    parallelize(workers: worker_count)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def login_admin
      post login_path, params: { email: "admin@example.com", password: "password" }
    end
  end
end
