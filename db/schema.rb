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

ActiveRecord::Schema[8.1].define(version: 2025_12_22_205753) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "boardgame_names", force: :cascade do |t|
    t.bigint "boardgame_id", null: false
    t.datetime "created_at", null: false
    t.boolean "preferred", default: false, null: false
    t.string "search_value"
    t.datetime "updated_at", null: false
    t.string "value", null: false
    t.index ["boardgame_id", "value"], name: "index_boardgame_names_on_boardgame_id_and_value", unique: true
    t.index ["boardgame_id"], name: "index_boardgame_names_on_boardgame_id"
    t.index ["search_value"], name: "index_boardgame_names_on_search_value_trgm", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "boardgames", force: :cascade do |t|
    t.integer "bgg_id"
    t.datetime "created_at", null: false
    t.string "image_url"
    t.integer "max_players"
    t.integer "max_playtime"
    t.integer "min_players"
    t.integer "min_playtime"
    t.string "normalized_title"
    t.integer "rank", default: 0, null: false
    t.string "thumbnail_url"
    t.string "title"
    t.datetime "updated_at", null: false
    t.float "weight"
    t.integer "year", default: 0, null: false
    t.index ["bgg_id"], name: "index_boardgames_on_bgg_id", unique: true
    t.index ["title"], name: "index_boardgames_on_title"
  end

  create_table "contact_messages", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.integer "status", default: 0, null: false
    t.integer "subject", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "user_agent", null: false
  end

  create_table "form_store_suggestions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "store_url", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identification_failures", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "identifiable_id", null: false
    t.string "identifiable_type", null: false
    t.string "reason"
    t.string "search_method", null: false
    t.datetime "updated_at", null: false
    t.index ["identifiable_type", "identifiable_id", "search_method"], name: "idx_on_identifiable_type_identifiable_id_search_met_35a8c6d625", unique: true
    t.index ["identifiable_type", "identifiable_id"], name: "index_identification_failures_on_identifiable"
  end

  create_table "impressions", force: :cascade do |t|
    t.integer "count"
    t.datetime "created_at", null: false
    t.date "date"
    t.bigint "trackable_id", null: false
    t.string "trackable_type", null: false
    t.datetime "updated_at", null: false
    t.index ["trackable_id", "trackable_type", "date"], name: "index_impressions_on_trackable_id_and_trackable_type_and_date", unique: true
    t.index ["trackable_type", "trackable_id"], name: "index_impressions_on_trackable"
  end

  create_table "listings", force: :cascade do |t|
    t.integer "boardgame_id"
    t.datetime "created_at", null: false
    t.boolean "is_boardgame", default: true, null: false
    t.string "normalized_title"
    t.integer "store_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["boardgame_id"], name: "index_listings_on_boardgame_id"
    t.index ["store_id"], name: "index_listings_on_store_id"
    t.index ["title"], name: "index_listings_on_title"
    t.index ["url"], name: "index_listings_on_url", unique: true
  end

  create_table "prices", force: :cascade do |t|
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.integer "listing_id", null: false
    t.datetime "updated_at", null: false
    t.index ["amount"], name: "index_prices_on_amount"
    t.index ["date"], name: "index_prices_on_date"
    t.index ["listing_id", "date"], name: "index_prices_on_listing_id_and_date", unique: true
    t.index ["listing_id"], name: "index_prices_on_listing_id"
    t.index ["updated_at"], name: "index_prices_on_updated_at"
  end

  create_table "store_suggestions", force: :cascade do |t|
    t.integer "count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
  end

  create_table "stores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
  end

  create_table "things_links", force: :cascade do |t|
    t.bigint "boardgame_id", null: false
    t.datetime "created_at", null: false
    t.integer "link_id"
    t.string "link_type"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["boardgame_id"], name: "index_things_links_on_boardgame_id"
  end

  create_table "things_ranks", force: :cascade do |t|
    t.float "bayesaverage"
    t.bigint "boardgame_id", null: false
    t.datetime "created_at", null: false
    t.string "friendlyname"
    t.string "name"
    t.integer "rank_id"
    t.string "rank_type"
    t.datetime "updated_at", null: false
    t.integer "value"
    t.index ["boardgame_id"], name: "index_things_ranks_on_boardgame_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "boardgame_names", "boardgames"
  add_foreign_key "listings", "stores"
  add_foreign_key "prices", "listings"
  add_foreign_key "things_links", "boardgames"
  add_foreign_key "things_ranks", "boardgames"

  create_view "boardgame_deals", materialized: true, sql_definition: <<-SQL
      WITH impression_counts AS (
           SELECT i_1.trackable_id AS boardgame_id,
              sum(i_1.count) AS view_count
             FROM (impressions i_1
               CROSS JOIN ( SELECT max(prices.date) AS t_date
                     FROM prices) d)
            WHERE ((i_1.date >= (d.t_date - 7)) AND ((i_1.trackable_type)::text = 'Boardgame'::text))
            GROUP BY i_1.trackable_id
          ), price_summary AS (
           SELECT b.id,
              b.title,
              b.rank,
              b.thumbnail_url,
              min(p_1.amount) FILTER (WHERE (p_1.date = d.t_date)) AS t_price,
              min(p_1.amount) FILTER (WHERE (p_1.date = d.y_date)) AS y_price,
              percentile_disc((0.5)::double precision) WITHIN GROUP (ORDER BY p_1.amount) AS m_price
             FROM (((boardgames b
               JOIN listings l ON ((l.boardgame_id = b.id)))
               JOIN prices p_1 ON ((p_1.listing_id = l.id)))
               CROSS JOIN ( SELECT max(prices.date) AS t_date,
                      (max(prices.date) - 1) AS y_date
                     FROM prices) d)
            WHERE (p_1.date > (d.t_date - 14))
            GROUP BY b.id, b.title, b.rank, b.thumbnail_url, d.t_date, d.y_date
          )
   SELECT p.id,
      p.title,
      p.rank,
      p.thumbnail_url,
      p.t_price,
      p.y_price,
      p.m_price,
      COALESCE(i.view_count, (0)::bigint) AS view_count_7d,
      (p.m_price - p.t_price) AS net_discount,
          CASE
              WHEN (p.m_price > 0) THEN (((100)::numeric * ((1.0 * ((p.m_price - p.t_price))::numeric) / (p.m_price)::numeric)))::integer
              ELSE 0
          END AS rel_discount_100,
      ((p.t_price < p.y_price) AND (p.y_price IS NOT NULL)) AS did_drop,
      ((p.rank > 0) AND (p.rank IS NOT NULL)) AS is_ranked
     FROM (price_summary p
       LEFT JOIN impression_counts i ON ((i.boardgame_id = p.id)));
  SQL
  add_index "boardgame_deals", ["id"], name: "index_boardgame_deals_on_id", unique: true

end
