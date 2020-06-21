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

ActiveRecord::Schema.define(version: 2020_06_21_120918) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "user_accounts", force: :cascade do |t|
    t.string "first_name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
    t.datetime "birth_date", null: false
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
  end

end
