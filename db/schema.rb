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

ActiveRecord::Schema[8.0].define(version: 2025_05_17_212351) do
  create_table "boardgames", force: :cascade do |t|
    t.string "title"
    t.integer "bgg_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rank", default: 0, null: false
    t.string "image_url"
    t.string "thumbnail_url"
    t.integer "year", default: 0, null: false
    t.integer "reference_price"
    t.integer "best_price"
    t.integer "discount"
    t.string "normalized_title"
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

  create_table "form_store_suggestions", force: :cascade do |t|
    t.string "store_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listings", force: :cascade do |t|
    t.string "title", null: false
    t.string "url", null: false
    t.integer "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "boardgame_id"
    t.boolean "is_boardgame", default: true, null: false
    t.boolean "failed_local_identification", default: false
    t.boolean "failed_bgg_api_identification", default: false
    t.string "normalized_title"
    t.index ["boardgame_id"], name: "index_listings_on_boardgame_id"
    t.index ["store_id"], name: "index_listings_on_store_id"
    t.index ["title"], name: "index_listings_on_title"
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

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "listings", "stores"
  add_foreign_key "prices", "listings"
end
