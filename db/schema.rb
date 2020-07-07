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

ActiveRecord::Schema.define(version: 2020_07_07_215402) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "confirmation_codes", force: :cascade do |t|
    t.string "confirmation_token"
    t.string "sms_code"
    t.integer "retry_count"
    t.datetime "generation_time"
    t.integer "failed_attempts_count"
    t.bigint "user_account_id", null: false
    t.bigint "confirmation_type_id", null: false
    t.index ["confirmation_type_id"], name: "index_confirmation_codes_on_confirmation_type_id"
    t.index ["user_account_id"], name: "index_confirmation_codes_on_user_account_id"
  end

  create_table "confirmation_types", force: :cascade do |t|
    t.string "name", limit: 150
    t.string "id_name", limit: 50
  end

  create_table "country_phone_indices", force: :cascade do |t|
    t.string "iso_code", limit: 2, null: false
    t.string "phone_index", limit: 10, null: false
    t.integer "length_limit", default: 9, null: false
  end

  create_table "customer_types", force: :cascade do |t|
    t.string "name"
    t.string "id_name"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "delivery_address"
    t.datetime "invoice_address"
    t.boolean "active", default: true, null: false
    t.integer "user_account_id"
    t.integer "customer_type_id", null: false
    t.string "legal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locking_types", force: :cascade do |t|
    t.json "name", null: false
    t.string "id_name", limit: 50
  end

  create_table "terms_and_condition_agreements", force: :cascade do |t|
    t.bigint "user_account_id", null: false
    t.bigint "terms_and_condition_id", null: false
    t.datetime "agreed_date"
    t.index ["terms_and_condition_id"], name: "index_terms_and_condition_agreements_on_terms_and_condition_id"
    t.index ["user_account_id"], name: "index_terms_and_condition_agreements_on_user_account_id"
  end

  create_table "terms_and_conditions", force: :cascade do |t|
    t.datetime "active_from", null: false
    t.string "version", limit: 50, null: false
    t.string "description"
    t.string "terms_and_condition"
  end

  create_table "user_accounts", force: :cascade do |t|
    t.string "phone_number", null: false
    t.string "email", null: false
    t.string "crypted_password", limit: 255, null: false
    t.boolean "active", default: false, null: false
    t.integer "failed_logins_count"
    t.date "last_attempt_date"
    t.boolean "locked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "salt"
    t.string "username"
    t.string "phone_number_iso", limit: 2, default: "de", null: false
  end

  add_foreign_key "confirmation_codes", "confirmation_types"
  add_foreign_key "confirmation_codes", "user_accounts"
  add_foreign_key "customers", "customer_types"
  add_foreign_key "terms_and_condition_agreements", "terms_and_conditions"
  add_foreign_key "terms_and_condition_agreements", "user_accounts"
end
