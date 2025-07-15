# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_15_174408) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "boardgame_names", force: :cascade do |t|
    t.bigint "boardgame_id", null: false
    t.string "value", null: false
    t.boolean "preferred", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boardgame_id", "value"], name: "index_boardgame_names_on_boardgame_id_and_value", unique: true
    t.index ["boardgame_id"], name: "index_boardgame_names_on_boardgame_id"
    t.index ["value"], name: "index_boardgame_names_on_value_trgm", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "boardgames", force: :cascade do |t|
    t.string "title"
    t.integer "bgg_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rank", default: 0, null: false
    t.string "image_url"
    t.string "thumbnail_url"
    t.integer "year", default: 0, null: false
    t.string "normalized_title"
    t.integer "min_players"
    t.integer "max_players"
    t.index ["bgg_id"], name: "index_boardgames_on_bgg_id", unique: true
    t.index ["title"], name: "index_boardgames_on_title"
  end

  create_table "contact_messages", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "body"
    t.string "user_agent", null: false
    t.integer "subject", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "daily_boardgame_deals", force: :cascade do |t|
    t.bigint "boardgame_id", null: false
    t.integer "best_price", default: 0, null: false
    t.integer "reference_price", default: 0, null: false
    t.integer "discount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boardgame_id"], name: "index_daily_boardgame_deals_on_boardgame_id"
  end

  create_table "form_store_suggestions", force: :cascade do |t|
    t.string "store_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identification_failures", force: :cascade do |t|
    t.string "identifiable_type", null: false
    t.bigint "identifiable_id", null: false
    t.string "search_method", null: false
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifiable_type", "identifiable_id", "search_method"], name: "idx_on_identifiable_type_identifiable_id_search_met_35a8c6d625", unique: true
    t.index ["identifiable_type", "identifiable_id"], name: "index_identification_failures_on_identifiable"
  end

  create_table "impressions", force: :cascade do |t|
    t.string "trackable_type", null: false
    t.bigint "trackable_id", null: false
    t.date "date"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trackable_id", "trackable_type", "date"], name: "index_impressions_on_trackable_id_and_trackable_type_and_date", unique: true
    t.index ["trackable_type", "trackable_id"], name: "index_impressions_on_trackable"
  end

  create_table "listings", force: :cascade do |t|
    t.string "title", null: false
    t.string "url", null: false
    t.integer "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "boardgame_id"
    t.boolean "is_boardgame", default: true, null: false
    t.string "normalized_title"
    t.index ["boardgame_id"], name: "index_listings_on_boardgame_id"
    t.index ["store_id"], name: "index_listings_on_store_id"
    t.index ["title"], name: "index_listings_on_title"
    t.index ["url"], name: "index_listings_on_url", unique: true
  end

  create_table "prices", force: :cascade do |t|
    t.integer "amount", null: false
    t.date "date", null: false
    t.integer "listing_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amount"], name: "index_prices_on_amount"
    t.index ["date"], name: "index_prices_on_date"
    t.index ["listing_id", "date"], name: "index_prices_on_listing_id_and_date", unique: true
    t.index ["listing_id"], name: "index_prices_on_listing_id"
  end

  create_table "store_suggestions", force: :cascade do |t|
    t.string "url", null: false
    t.integer "count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "things_links", force: :cascade do |t|
    t.bigint "boardgame_id", null: false
    t.string "link_type"
    t.integer "link_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boardgame_id"], name: "index_things_links_on_boardgame_id"
  end

  create_table "things_ranks", force: :cascade do |t|
    t.bigint "boardgame_id", null: false
    t.string "rank_type"
    t.integer "rank_id"
    t.string "name"
    t.string "friendlyname"
    t.integer "value"
    t.float "bayesaverage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boardgame_id"], name: "index_things_ranks_on_boardgame_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "boardgame_names", "boardgames"
  add_foreign_key "daily_boardgame_deals", "boardgames"
  add_foreign_key "listings", "stores"
  add_foreign_key "prices", "listings"
  add_foreign_key "things_links", "boardgames"
  add_foreign_key "things_ranks", "boardgames"
end
