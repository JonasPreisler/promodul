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

ActiveRecord::Schema.define(version: 2020_12_12_172906) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "business_types", force: :cascade do |t|
    t.json "name", null: false
    t.string "id_name", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.json "name", null: false
    t.string "id_name", limit: 50
    t.boolean "active", default: true, null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.string "city_code", null: false
    t.bigint "country_id", null: false
    t.index ["country_id"], name: "index_cities_on_country_id"
  end

  create_table "client_contacts", force: :cascade do |t|
    t.string "first_name", limit: 50, null: false
    t.string "last_name"
    t.string "email", limit: 50
    t.string "phone", null: false
    t.string "position"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_contacts_on_client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "address"
    t.string "vat_number", limit: 50
    t.boolean "active", default: true, null: false
    t.bigint "user_account_id", null: false
    t.bigint "country_id", null: false
    t.bigint "city_id", null: false
    t.bigint "clients_group_id", null: false
    t.bigint "clients_type_id", null: false
    t.bigint "currency_id", null: false
    t.string "phone"
    t.string "web_address"
    t.string "kunde_nr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_vat_type_id"
    t.index ["city_id"], name: "index_clients_on_city_id"
    t.index ["clients_group_id"], name: "index_clients_on_clients_group_id"
    t.index ["clients_type_id"], name: "index_clients_on_clients_type_id"
    t.index ["country_id"], name: "index_clients_on_country_id"
    t.index ["currency_id"], name: "index_clients_on_currency_id"
    t.index ["product_vat_type_id"], name: "index_clients_on_product_vat_type_id"
    t.index ["user_account_id"], name: "index_clients_on_user_account_id"
  end

  create_table "clients_groups", force: :cascade do |t|
    t.json "name", null: false
    t.string "id_name", limit: 50
  end

  create_table "clients_types", force: :cascade do |t|
    t.json "name", null: false
    t.string "id_name", limit: 50
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "address"
    t.string "phone_number"
    t.bigint "country_id"
    t.bigint "city_id"
    t.integer "parent_id"
    t.boolean "active", default: true
    t.index ["city_id"], name: "index_companies_on_city_id"
    t.index ["country_id"], name: "index_companies_on_country_id"
  end

  create_table "company_logos", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "logo", limit: 50
    t.uuid "uuid", null: false
    t.index ["company_id"], name: "index_company_logos_on_company_id"
    t.index ["uuid"], name: "index_company_logos_on_uuid", unique: true
  end

  create_table "company_permissions", force: :cascade do |t|
    t.bigint "role_group_id", null: false
    t.boolean "read_data", default: false
    t.boolean "create_data", default: false
    t.boolean "edit_data", default: false
    t.boolean "delete_record", default: false
    t.boolean "activate_data", default: false
    t.boolean "no_access", default: true
    t.index ["role_group_id"], name: "index_company_permissions_on_role_group_id"
  end

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

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "country_code", null: false
  end

  create_table "country_phone_indices", force: :cascade do |t|
    t.string "iso_code", limit: 2, null: false
    t.string "phone_index", limit: 10, null: false
    t.integer "length_limit", default: 9, null: false
  end

  create_table "coupon_codes", force: :cascade do |t|
    t.integer "coupon_promotion_id"
    t.string "code"
    t.index ["coupon_promotion_id", "code"], name: "index_coupon_codes_on_coupon_promotion_id_and_code", unique: true
  end

  create_table "currencies", force: :cascade do |t|
    t.json "name", null: false
    t.string "symbol", limit: 20, null: false
    t.string "code", limit: 3, null: false
    t.index ["code"], name: "index_currencies_on_code", unique: true
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

  create_table "department_logos", force: :cascade do |t|
    t.bigint "department_id", null: false
    t.string "logo", limit: 50
    t.uuid "uuid", null: false
    t.index ["department_id"], name: "index_department_logos_on_department_id"
    t.index ["uuid"], name: "index_department_logos_on_uuid", unique: true
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "address"
    t.string "phone_number"
    t.bigint "country_id", null: false
    t.bigint "city_id", null: false
    t.bigint "company_id", null: false
    t.integer "parent_id"
    t.boolean "active", default: true
    t.index ["city_id"], name: "index_departments_on_city_id"
    t.index ["company_id"], name: "index_departments_on_company_id"
    t.index ["country_id"], name: "index_departments_on_country_id"
  end

  create_table "integration_systems", force: :cascade do |t|
    t.string "name"
  end

  create_table "locking_types", force: :cascade do |t|
    t.json "name", null: false
    t.string "id_name", limit: 50
  end

  create_table "order_products", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "order_id", null: false
    t.integer "count", null: false
    t.index ["order_id"], name: "index_order_products_on_order_id"
    t.index ["product_id"], name: "index_order_products_on_product_id"
  end

  create_table "order_statuses", force: :cascade do |t|
    t.json "name", null: false
    t.string "id_name", null: false
  end

  create_table "order_types", force: :cascade do |t|
    t.json "name", null: false
    t.string "id_name", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "title", limit: 50, null: false
    t.string "description"
    t.bigint "client_id", null: false
    t.bigint "order_type_id", null: false
    t.bigint "order_status_id", null: false
    t.bigint "user_account_id"
    t.datetime "start_time", null: false
    t.string "deadline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["order_status_id"], name: "index_orders_on_order_status_id"
    t.index ["order_type_id"], name: "index_orders_on_order_type_id"
    t.index ["user_account_id"], name: "index_orders_on_user_account_id"
  end

  create_table "product_catalog_permissions", force: :cascade do |t|
    t.bigint "role_group_id", null: false
    t.boolean "read_data", default: false
    t.boolean "create_data", default: false
    t.boolean "edit_data", default: false
    t.boolean "set_price_data", default: false
    t.boolean "delete_record", default: false
    t.boolean "no_access", default: true
    t.index ["role_group_id"], name: "index_product_catalog_permissions_on_role_group_id"
  end

  create_table "product_characteristics", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "sub_category_id", null: false
    t.string "volume"
    t.string "manufacturer"
    t.string "description"
    t.string "external_code", limit: 50
    t.string "EAN_code", limit: 50
    t.decimal "weight"
    t.decimal "width"
    t.decimal "height"
    t.decimal "depth"
    t.integer "product_type_id"
    t.integer "product_vat_type_id"
    t.boolean "subscription", default: false
    t.boolean "commission", default: false
    t.index ["product_id"], name: "index_product_characteristics_on_product_id"
    t.index ["product_type_id"], name: "index_product_characteristics_on_product_type_id"
    t.index ["product_vat_type_id"], name: "index_product_characteristics_on_product_vat_type_id"
    t.index ["sub_category_id"], name: "index_product_characteristics_on_sub_category_id"
  end

  create_table "product_group_permissions", force: :cascade do |t|
    t.bigint "role_group_id", null: false
    t.boolean "read_data", default: false
    t.boolean "create_data", default: false
    t.boolean "edit_data", default: false
    t.boolean "activate_data", default: false
    t.boolean "delete_record", default: false
    t.boolean "no_access", default: true
    t.index ["role_group_id"], name: "index_product_group_permissions_on_role_group_id"
  end

  create_table "product_images", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "image", limit: 50
    t.uuid "uuid", null: false
    t.index ["product_id"], name: "index_product_images_on_product_id"
    t.index ["uuid"], name: "index_product_images_on_uuid", unique: true
  end

  create_table "product_import_permissions", force: :cascade do |t|
    t.bigint "role_group_id", null: false
    t.boolean "import", default: false
    t.boolean "no_access", default: true
    t.index ["role_group_id"], name: "index_product_import_permissions_on_role_group_id"
  end

  create_table "product_prices", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "list_price_type", limit: 30, null: false
    t.decimal "list_price_amount", null: false
    t.decimal "manufacturing_cost", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_prices_on_product_id"
  end

  create_table "product_type_permissions", force: :cascade do |t|
    t.bigint "role_group_id", null: false
    t.boolean "read_data", default: false
    t.boolean "create_data", default: false
    t.boolean "edit_data", default: false
    t.boolean "activate_data", default: false
    t.boolean "delete_record", default: false
    t.boolean "no_access", default: true
    t.index ["role_group_id"], name: "index_product_type_permissions_on_role_group_id"
  end

  create_table "product_types", force: :cascade do |t|
    t.json "name", null: false
    t.string "id_name", null: false
    t.boolean "active", default: true
  end

  create_table "product_vat_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "id_name", null: false
  end

  create_table "products", force: :cascade do |t|
    t.json "name", null: false
    t.json "full_name", null: false
    t.string "description", null: false
    t.string "code", null: false
    t.string "instruction", limit: 500
    t.boolean "active", default: true
    t.index ["code"], name: "index_products_on_code", unique: true
  end

  create_table "role_groups", force: :cascade do |t|
    t.string "name", null: false
    t.string "id_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "role_management_permissions", force: :cascade do |t|
    t.bigint "role_group_id", null: false
    t.boolean "read_data", default: false
    t.boolean "create_data", default: false
    t.boolean "edit_data", default: false
    t.boolean "delete_record", default: false
    t.boolean "activate_data", default: false
    t.boolean "no_access", default: true
    t.index ["role_group_id"], name: "index_role_management_permissions_on_role_group_id"
  end

  create_table "sub_categories", force: :cascade do |t|
    t.json "name", null: false
    t.string "id_name", limit: 50
    t.boolean "active", default: true, null: false
    t.integer "category_id", null: false
  end

  create_table "supplier_product_prices", force: :cascade do |t|
    t.bigint "supplier_product_id", null: false
    t.decimal "price", null: false
    t.decimal "price_per_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "currency_id"
    t.index ["currency_id"], name: "supplier_product_prices_currency"
    t.index ["supplier_product_id"], name: "index_supplier_product_prices_on_supplier_product_id"
  end

  create_table "supplier_products", force: :cascade do |t|
    t.bigint "supplier_id", null: false
    t.bigint "product_id", null: false
    t.string "supplier_code"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.index ["product_id"], name: "index_supplier_products_on_product_id"
    t.index ["supplier_id"], name: "index_supplier_products_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.datetime "registration_date"
    t.boolean "active"
    t.bigint "integration_system_id", null: false
    t.bigint "business_type_id", null: false
    t.string "name", null: false
    t.string "identification_code", null: false
    t.string "phone_number"
    t.index ["business_type_id"], name: "index_suppliers_on_business_type_id"
    t.index ["integration_system_id"], name: "index_suppliers_on_integration_system_id"
  end

  create_table "suppliers_permissions", force: :cascade do |t|
    t.bigint "role_group_id", null: false
    t.boolean "read_data", default: false
    t.boolean "create_data", default: false
    t.boolean "edit_data", default: false
    t.boolean "delete_record", default: false
    t.boolean "activate_data", default: false
    t.boolean "no_access", default: true
    t.index ["role_group_id"], name: "index_suppliers_permissions_on_role_group_id"
  end

  create_table "system_data_permissions", force: :cascade do |t|
    t.bigint "role_group_id", null: false
    t.boolean "read_data", default: false
    t.boolean "create_data", default: false
    t.boolean "edit_data", default: false
    t.boolean "delete_record", default: false
    t.boolean "activate_data", default: false
    t.boolean "no_access", default: true
    t.index ["role_group_id"], name: "index_system_data_permissions_on_role_group_id"
  end

  create_table "task_statuses", force: :cascade do |t|
    t.json "name", null: false
    t.string "id_name", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title", limit: 50, null: false
    t.string "description"
    t.bigint "task_status_id", null: false
    t.bigint "product_id", null: false
    t.bigint "order_id", null: false
    t.bigint "user_account_id"
    t.datetime "start_time", null: false
    t.datetime "deadline"
    t.string "tracked_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_tasks_on_order_id"
    t.index ["product_id"], name: "index_tasks_on_product_id"
    t.index ["task_status_id"], name: "index_tasks_on_task_status_id"
    t.index ["user_account_id"], name: "index_tasks_on_user_account_id"
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

  create_table "user_management_permissions", force: :cascade do |t|
    t.bigint "role_group_id", null: false
    t.boolean "read_data", default: false
    t.boolean "manage_data", default: false
    t.boolean "activate_data", default: false
    t.boolean "no_access", default: true
    t.index ["role_group_id"], name: "index_user_management_permissions_on_role_group_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_account_id", null: false
    t.bigint "role_group_id", null: false
    t.index ["role_group_id"], name: "index_user_roles_on_role_group_id"
    t.index ["user_account_id"], name: "index_user_roles_on_user_account_id"
  end

  add_foreign_key "cities", "countries"
  add_foreign_key "client_contacts", "clients"
  add_foreign_key "clients", "cities"
  add_foreign_key "clients", "clients_groups"
  add_foreign_key "clients", "clients_types"
  add_foreign_key "clients", "countries"
  add_foreign_key "clients", "currencies"
  add_foreign_key "clients", "product_vat_types"
  add_foreign_key "clients", "user_accounts"
  add_foreign_key "companies", "cities"
  add_foreign_key "companies", "companies", column: "parent_id"
  add_foreign_key "companies", "countries"
  add_foreign_key "company_logos", "companies"
  add_foreign_key "company_permissions", "role_groups"
  add_foreign_key "confirmation_codes", "confirmation_types"
  add_foreign_key "confirmation_codes", "user_accounts"
  add_foreign_key "customers", "customer_types"
  add_foreign_key "department_logos", "departments"
  add_foreign_key "departments", "cities"
  add_foreign_key "departments", "companies"
  add_foreign_key "departments", "countries"
  add_foreign_key "departments", "departments", column: "parent_id"
  add_foreign_key "order_products", "orders"
  add_foreign_key "order_products", "products"
  add_foreign_key "orders", "clients"
  add_foreign_key "orders", "order_statuses"
  add_foreign_key "orders", "order_types"
  add_foreign_key "orders", "user_accounts"
  add_foreign_key "product_catalog_permissions", "role_groups"
  add_foreign_key "product_characteristics", "products"
  add_foreign_key "product_characteristics", "sub_categories"
  add_foreign_key "product_group_permissions", "role_groups"
  add_foreign_key "product_images", "products"
  add_foreign_key "product_import_permissions", "role_groups"
  add_foreign_key "product_prices", "products"
  add_foreign_key "product_type_permissions", "role_groups"
  add_foreign_key "role_management_permissions", "role_groups"
  add_foreign_key "sub_categories", "categories"
  add_foreign_key "supplier_product_prices", "currencies"
  add_foreign_key "supplier_product_prices", "supplier_products"
  add_foreign_key "supplier_products", "products"
  add_foreign_key "supplier_products", "suppliers"
  add_foreign_key "suppliers", "business_types"
  add_foreign_key "suppliers", "integration_systems"
  add_foreign_key "suppliers_permissions", "role_groups"
  add_foreign_key "system_data_permissions", "role_groups"
  add_foreign_key "tasks", "orders"
  add_foreign_key "tasks", "products"
  add_foreign_key "tasks", "task_statuses"
  add_foreign_key "tasks", "user_accounts"
  add_foreign_key "terms_and_condition_agreements", "terms_and_conditions"
  add_foreign_key "terms_and_condition_agreements", "user_accounts"
  add_foreign_key "user_management_permissions", "role_groups"
  add_foreign_key "user_roles", "role_groups"
  add_foreign_key "user_roles", "user_accounts"
end
