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

ActiveRecord::Schema.define(version: 2025_05_01_143535) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "addresses", force: :cascade do |t|
    t.string "description"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deletion_mark", default: false
    t.string "unf_id"
    t.string "name"
    t.index ["client_id"], name: "index_addresses_on_client_id"
  end

  create_table "asighnclients", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_asighnclients_on_client_id"
    t.index ["user_id"], name: "index_asighnclients_on_user_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "stick", default: false
    t.boolean "stick_pack", default: false
    t.bigint "client_id"
    t.index ["client_id"], name: "index_carts_on_client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_folder"
    t.string "unf_id"
    t.string "parent_id"
    t.string "parent_name"
    t.boolean "deletion_mark", default: false
    t.string "user_type"
    t.bigint "user_id"
    t.bigint "pricetype_id"
    t.boolean "not_active", default: false
    t.bigint "access_group_id"
    t.index ["access_group_id"], name: "index_clients_on_access_group_id"
    t.index ["pricetype_id"], name: "index_clients_on_pricetype_id"
    t.index ["user_type", "user_id"], name: "index_clients_on_user_type_and_user_id"
  end

  create_table "exch_nodes", force: :cascade do |t|
    t.string "node"
    t.string "ser"
    t.string "cat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code_unf"
  end

  create_table "favorite_products", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
    t.bigint "pack_id"
    t.index ["client_id"], name: "index_favorite_products_on_client_id"
    t.index ["pack_id"], name: "index_favorite_products_on_pack_id"
    t.index ["product_id"], name: "index_favorite_products_on_product_id"
    t.index ["user_id"], name: "index_favorite_products_on_user_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "date"
    t.string "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unf_number"
    t.bigint "storage_place_id"
    t.float "sum"
    t.integer "status"
    t.integer "inv_type"
    t.index ["storage_place_id"], name: "index_inventories_on_storage_place_id"
    t.index ["user_id"], name: "index_inventories_on_user_id"
  end

  create_table "inventory_line_items", force: :cascade do |t|
    t.bigint "product_id"
    t.float "qty"
    t.float "price"
    t.float "sum"
    t.string "comment"
    t.bigint "inventory_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "unit_product_id"
    t.string "product_name"
    t.decimal "rko"
    t.decimal "row_number"
    t.index ["inventory_id"], name: "index_inventory_line_items_on_inventory_id"
    t.index ["product_id"], name: "index_inventory_line_items_on_product_id"
    t.index ["unit_product_id"], name: "index_inventory_line_items_on_unit_product_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "cart_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "quantity", default: 0.0
    t.bigint "order_id"
    t.bigint "pack_id"
    t.bigint "unit_id"
    t.integer "pack_type_id"
    t.integer "amount", default: 0
    t.string "product_unf_id"
    t.boolean "stick", default: false
    t.string "comment"
    t.float "recount"
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["pack_id"], name: "index_line_items_on_pack_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
    t.index ["unit_id"], name: "index_line_items_on_unit_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "client_id"
    t.date "date"
    t.text "shipping_address"
    t.bigint "user_id"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "stick", default: false
    t.boolean "stick_pack", default: false
    t.boolean "deletion_mark", default: false
    t.bigint "address_id"
    t.boolean "server_unf"
    t.datetime "server_unf_date"
    t.boolean "pickup", default: false
    t.boolean "certificate", default: false
    t.boolean "postponement", default: false
    t.boolean "return", default: false
    t.boolean "return_item", default: false
    t.index ["address_id"], name: "index_orders_on_address_id"
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "packs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "product_id"
    t.integer "type_id"
    t.float "weight"
    t.boolean "deletion_mark", default: false
    t.boolean "not_active", default: false
  end

  create_table "prices", force: :cascade do |t|
    t.decimal "value"
    t.date "period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.bigint "pack_id"
    t.bigint "pricetype_id"
    t.bigint "unit_product_id"
    t.index ["pack_id"], name: "index_prices_on_pack_id"
    t.index ["pricetype_id"], name: "index_prices_on_pricetype_id"
    t.index ["product_id"], name: "index_prices_on_product_id"
    t.index ["unit_product_id"], name: "index_prices_on_unit_product_id"
  end

  create_table "pricetypes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deletion_mark", default: false
    t.string "unf_id"
  end

  create_table "product_exeptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.bigint "client_id"
    t.index ["client_id"], name: "index_product_exeptions_on_client_id"
    t.index ["product_id"], name: "index_product_exeptions_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "image_url"
    t.decimal "price", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_folder", default: false
    t.integer "parent_id"
    t.string "parent_name"
    t.string "unf_id"
    t.string "unf_parent_id"
    t.float "weight"
    t.string "full_name"
    t.boolean "deletion_mark", default: false
    t.integer "order_id"
    t.boolean "not_active", default: false
    t.decimal "rko"
  end

  create_table "storage_places", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unf_id"
    t.string "title"
  end

  create_table "unit_products", force: :cascade do |t|
    t.string "name"
    t.boolean "default", default: false
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deletion_mark", default: false
    t.float "ratio", default: 1.0
    t.string "unf_id"
    t.index ["product_id"], name: "index_unit_products_on_product_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "piece"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "surname"
    t.bigint "unit_id"
    t.string "email"
    t.integer "role", default: 0
    t.bigint "access_group_id"
    t.string "unf_id"
    t.bigint "storage_place_id"
    t.index ["access_group_id"], name: "index_users_on_access_group_id"
    t.index ["storage_place_id"], name: "index_users_on_storage_place_id"
    t.index ["unit_id"], name: "index_users_on_unit_id"
  end

  add_foreign_key "addresses", "clients"
  add_foreign_key "asighnclients", "clients"
  add_foreign_key "asighnclients", "users"
  add_foreign_key "carts", "clients"
  add_foreign_key "clients", "access_groups"
  add_foreign_key "clients", "pricetypes"
  add_foreign_key "favorite_products", "clients"
  add_foreign_key "favorite_products", "packs"
  add_foreign_key "favorite_products", "products"
  add_foreign_key "favorite_products", "users"
  add_foreign_key "inventories", "storage_places"
  add_foreign_key "inventories", "users"
  add_foreign_key "inventory_line_items", "inventories"
  add_foreign_key "inventory_line_items", "products"
  add_foreign_key "inventory_line_items", "unit_products"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "packs"
  add_foreign_key "line_items", "units"
  add_foreign_key "orders", "addresses"
  add_foreign_key "orders", "clients"
  add_foreign_key "orders", "users"
  add_foreign_key "prices", "packs"
  add_foreign_key "prices", "pricetypes"
  add_foreign_key "prices", "products"
  add_foreign_key "prices", "unit_products"
  add_foreign_key "product_exeptions", "clients"
  add_foreign_key "product_exeptions", "products"
  add_foreign_key "users", "access_groups"
  add_foreign_key "users", "storage_places"
  add_foreign_key "users", "units"
end
