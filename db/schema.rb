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

ActiveRecord::Schema[7.1].define(version: 2025_02_03_133307) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.integer "quantity"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "size_id", null: false
    t.index ["product_id"], name: "index_cart_items_on_product_id"
    t.index ["size_id"], name: "index_cart_items_on_size_id"
    t.index ["user_id"], name: "index_cart_items_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "parent_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_categories_on_deleted_at"
    t.index ["parent_category_id"], name: "index_categories_on_parent_category_id"
  end

  create_table "category_products", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_products_on_category_id"
    t.index ["product_id"], name: "index_category_products_on_product_id"
  end

  create_table "chats", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.bigint "admin_user_id"
    t.text "question", null: false
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_chats_on_admin_user_id"
    t.index ["product_id"], name: "index_chats_on_product_id"
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "order_product_vouchers", force: :cascade do |t|
    t.bigint "voucher_id", null: false
    t.bigint "order_product_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_product_id"], name: "index_order_product_vouchers_on_order_product_id"
    t.index ["voucher_id"], name: "index_order_product_vouchers_on_voucher_id"
  end

  create_table "order_products", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_products_on_order_id"
    t.index ["product_id"], name: "index_order_products_on_product_id"
  end

  create_table "order_vouchers", force: :cascade do |t|
    t.bigint "voucher_id", null: false
    t.bigint "order_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_vouchers_on_order_id"
    t.index ["voucher_id"], name: "index_order_vouchers_on_voucher_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "status", default: "placed"
    t.float "grand_total"
    t.float "final_total"
    t.bigint "user_id", null: false
    t.text "delivery_address"
    t.text "payment_address"
    t.string "payment_method"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.float "amount"
    t.string "payment_method"
    t.string "status", default: "pending"
    t.string "currency", default: "PKR"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "product_sizes", force: :cascade do |t|
    t.float "price"
    t.string "currency"
    t.integer "quantity"
    t.bigint "size_id", null: false
    t.bigint "product_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "size_id"], name: "index_product_sizes_on_product_id_and_size_id"
    t.index ["product_id"], name: "index_product_sizes_on_product_id"
    t.index ["size_id"], name: "index_product_sizes_on_size_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.float "discount_percentage", default: 0.0
    t.string "description"
    t.boolean "discontinued", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sizes", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key", default: "", null: false
    t.integer "order"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vouchers", force: :cascade do |t|
    t.string "token"
    t.string "applied_type"
    t.string "discount_type"
    t.float "discount_value"
    t.float "cap_amount"
    t.boolean "discontinued", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "cart_items", "products"
  add_foreign_key "cart_items", "sizes"
  add_foreign_key "cart_items", "users"
  add_foreign_key "categories", "categories", column: "parent_category_id"
  add_foreign_key "category_products", "categories"
  add_foreign_key "category_products", "products"
  add_foreign_key "chats", "admin_users"
  add_foreign_key "chats", "products"
  add_foreign_key "chats", "users"
  add_foreign_key "order_product_vouchers", "order_products"
  add_foreign_key "order_product_vouchers", "vouchers"
  add_foreign_key "order_products", "orders"
  add_foreign_key "order_products", "products"
  add_foreign_key "order_vouchers", "orders"
  add_foreign_key "order_vouchers", "vouchers"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "product_sizes", "products"
  add_foreign_key "product_sizes", "sizes"
end
