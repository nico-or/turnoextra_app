# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Rake::Task['info'].invoke

Rails.logger.info 'Seeding database...'

Rails.logger.info 'Creating admin user...'

User.find_or_create_by(email: ENV['ADMIN_EMAIL']) do |u|
  u.admin = true
  u.password_digest = BCrypt::Password.create(ENV['ADMIN_PASSWORD'])
end

Rails.logger.info 'Creating boardgames...'
Rake::Task['boardgame:update_ranks'].invoke
# TODO: Update Boardgame data from BGG (needs identification (?) to avoid fetching ALL boardgames)

Rails.logger.info 'Importing listings...'
Rake::Task['listing:import'].invoke

# TODO: Perform listing identification (needs to be faster or local)
# Rake::Task['listing:identify'].invoke


# TODO: Update Boardgames reference_price (needs identification)
# Rake::Task['boardgame:update_reference_prices'].invoke

Rails.logger.info 'Seeding complete.'
