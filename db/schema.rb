# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180305204033) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "stocks", force: :cascade do |t|
    t.bigint "store_id"
    t.bigint "wine_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_stocks_on_store_id"
    t.index ["wine_id"], name: "index_stocks_on_wine_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "banner"
    t.string "name"
    t.string "address"
    t.string "phone_number"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "store_identifier"
    t.integer "location_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wines", force: :cascade do |t|
    t.string "name"
    t.string "variety"
    t.string "colour"
    t.integer "year"
    t.float "rating"
    t.float "price"
    t.string "photo_url"
    t.boolean "pairs_with_meat"
    t.boolean "pairs_with_seafood"
    t.boolean "pairs_with_cheese"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "saq_code"
    t.string "url"
    t.string "volume"
    t.string "country"
  end

  add_foreign_key "stocks", "stores"
  add_foreign_key "stocks", "wines"
end
