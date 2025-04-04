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

ActiveRecord::Schema[8.0].define(version: 2025_04_04_215510) do
  create_table "boardgames", force: :cascade do |t|
    t.string "title"
    t.integer "bgg_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rank", default: 0, null: false
    t.integer "latest_price"
    t.index ["bgg_id"], name: "index_boardgames_on_bgg_id", unique: true
  end

  create_table "listings", force: :cascade do |t|
    t.string "title", null: false
    t.string "url", null: false
    t.integer "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "boardgame_id"
    t.boolean "failed_identification", default: false
    t.index ["boardgame_id"], name: "index_listings_on_boardgame_id"
    t.index ["store_id"], name: "index_listings_on_store_id"
  end

  create_table "prices", force: :cascade do |t|
    t.integer "price", null: false
    t.date "date", null: false
    t.integer "listing_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_prices_on_listing_id"
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
