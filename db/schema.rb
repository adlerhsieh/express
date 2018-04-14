# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20180414120819) do

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "slug",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "image",      limit: 255
  end

  create_table "post_tags", force: :cascade do |t|
    t.integer  "post_id",    limit: 4
    t.integer  "tag_id",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.text     "content",      limit: 65535
    t.string   "slug",         limit: 255
    t.integer  "category_id",  limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "author_id",    limit: 4
    t.date     "display_date"
    t.boolean  "is_public",    limit: 1,     default: false
    t.text     "video_embed",  limit: 65535
    t.text     "abstract",     limit: 65535
    t.date     "sent"
    t.string   "image",        limit: 255
    t.string   "icon",         limit: 255
  end

  create_table "screencasts", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.text     "video_embed",    limit: 65535
    t.text     "content",        limit: 65535
    t.string   "training_id",    limit: 255
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "slug",           limit: 255
    t.date     "display_date"
    t.text     "image_embed",    limit: 65535
    t.integer  "author_id",      limit: 4
    t.boolean  "is_public",      limit: 1,     default: false
    t.integer  "training_order", limit: 4
    t.integer  "category_id",    limit: 4
    t.string   "icon",           limit: 255
  end

  create_table "settings", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.text     "value",      limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "tag",        limit: 255
  end

  create_table "store_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "store_images", force: :cascade do |t|
    t.string   "image",      limit: 255
    t.integer  "product_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "store_order_infos", force: :cascade do |t|
    t.string   "shipping_name",    limit: 255
    t.string   "shipping_address", limit: 255
    t.integer  "order_id",         limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "phone",            limit: 255
    t.string   "pkg_id",           limit: 255
  end

  create_table "store_order_items", force: :cascade do |t|
    t.integer  "quantity",   limit: 4
    t.integer  "price",      limit: 4
    t.integer  "order_id",   limit: 4
    t.integer  "product_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "store_orders", force: :cascade do |t|
    t.integer  "price",             limit: 4
    t.boolean  "paid",              limit: 1
    t.string   "token",             limit: 255
    t.integer  "payment_method_id", limit: 4
    t.string   "aasm_state",        limit: 255
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.datetime "order_time"
    t.datetime "pay_time"
    t.datetime "shipping_time"
    t.integer  "user_id",           limit: 4
    t.text     "note",              limit: 65535
    t.datetime "arrived_at"
    t.datetime "returned_at"
    t.datetime "cancelled_at"
    t.integer  "shipping_fee",      limit: 4,     default: 0
  end

  create_table "store_payment_methods", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "store_payment_notifiers", force: :cascade do |t|
    t.text     "params",         limit: 65535
    t.integer  "order_id",       limit: 4
    t.string   "status",         limit: 255
    t.string   "transaction_id", limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "store_payment_transfers", force: :cascade do |t|
    t.integer  "order_id",       limit: 4
    t.string   "status",         limit: 255
    t.string   "transaction_id", limit: 255
    t.boolean  "confirm",        limit: 1
    t.datetime "confirm_time"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "store_products", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.string   "description",   limit: 255
    t.integer  "stock",         limit: 4
    t.integer  "price",         limit: 4
    t.string   "default_image", limit: 255
    t.integer  "category_id",   limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "display",       limit: 1,   default: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "slug",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "trainings", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.text     "content",      limit: 65535
    t.text     "video_embed",  limit: 65535
    t.text     "image_embed",  limit: 65535
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "slug",         limit: 255
    t.date     "display_date"
    t.integer  "author_id",    limit: 4
    t.boolean  "is_public",    limit: 1,     default: false
    t.integer  "category_id",  limit: 4
    t.boolean  "skip",         limit: 1,     default: true
  end

  create_table "user_addresses", force: :cascade do |t|
    t.string   "address",    limit: 255
    t.string   "phone",      limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "user_emails", force: :cascade do |t|
    t.string   "address",           limit: 255
    t.boolean  "blog_subscription", limit: 1
    t.integer  "user_id",           limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "user_products", force: :cascade do |t|
    t.integer  "product_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin",               limit: 1,   default: false
    t.string   "name",                   limit: 255
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
