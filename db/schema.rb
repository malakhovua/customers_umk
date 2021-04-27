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

ActiveRecord::Schema.define(version: 2021_04_25_140836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
  end

  create_table "exch_nodes", force: :cascade do |t|
    t.string "node"
    t.string "ser"
    t.string "cat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorite_products", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
    t.index ["client_id"], name: "index_favorite_products_on_client_id"
    t.index ["product_id"], name: "index_favorite_products_on_product_id"
    t.index ["user_id"], name: "index_favorite_products_on_user_id"
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
    t.integer "amount"
    t.string "product_unf_id"
    t.boolean "stick", default: false
    t.string "comment"
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
  end

  create_table "prices", force: :cascade do |t|
    t.decimal "value"
    t.date "period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.bigint "pack_id"
    t.bigint "pricetype_id"
    t.index ["pack_id"], name: "index_prices_on_pack_id"
    t.index ["pricetype_id"], name: "index_prices_on_pricetype_id"
    t.index ["product_id"], name: "index_prices_on_product_id"
  end

  create_table "pricetypes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  add_foreign_key "carts", "clients"
  add_foreign_key "favorite_products", "clients"
  add_foreign_key "favorite_products", "products"
  add_foreign_key "favorite_products", "users"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "packs"
  add_foreign_key "line_items", "units"
  add_foreign_key "orders", "clients"
  add_foreign_key "orders", "users"
  add_foreign_key "prices", "packs"
  add_foreign_key "prices", "pricetypes"
  add_foreign_key "prices", "products"
end
