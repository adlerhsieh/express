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

ActiveRecord::Schema.define(version: 20150611143843) do

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "slug",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "image",      limit: 255
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer  "category_id", limit: 4,   null: false
    t.string   "locale",      limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "name",        limit: 255
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id", using: :btree
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale", using: :btree

  create_table "post_tags", force: :cascade do |t|
    t.integer  "post_id",    limit: 4
    t.integer  "tag_id",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "post_translations", force: :cascade do |t|
    t.integer  "post_id",    limit: 4,     null: false
    t.string   "locale",     limit: 255,   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "title",      limit: 255
    t.text     "content",    limit: 65535
  end

  add_index "post_translations", ["locale"], name: "index_post_translations_on_locale", using: :btree
  add_index "post_translations", ["post_id"], name: "index_post_translations_on_post_id", using: :btree

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

  create_table "screencast_translations", force: :cascade do |t|
    t.integer  "screencast_id", limit: 4,     null: false
    t.string   "locale",        limit: 255,   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "title",         limit: 255
    t.text     "content",       limit: 65535
  end

  add_index "screencast_translations", ["locale"], name: "index_screencast_translations_on_locale", using: :btree
  add_index "screencast_translations", ["screencast_id"], name: "index_screencast_translations_on_screencast_id", using: :btree

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
  end

  create_table "setting_translations", force: :cascade do |t|
    t.integer  "setting_id", limit: 4,     null: false
    t.string   "locale",     limit: 255,   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "value",      limit: 65535
  end

  add_index "setting_translations", ["locale"], name: "index_setting_translations_on_locale", using: :btree
  add_index "setting_translations", ["setting_id"], name: "index_setting_translations_on_setting_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.text     "value",      limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "tag",        limit: 255
  end

  create_table "tag_translations", force: :cascade do |t|
    t.integer  "tag_id",     limit: 4,   null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "name",       limit: 255
  end

  add_index "tag_translations", ["locale"], name: "index_tag_translations_on_locale", using: :btree
  add_index "tag_translations", ["tag_id"], name: "index_tag_translations_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "slug",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "training_translations", force: :cascade do |t|
    t.integer  "training_id", limit: 4,     null: false
    t.string   "locale",      limit: 255,   null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title",       limit: 255
    t.text     "content",     limit: 65535
  end

  add_index "training_translations", ["locale"], name: "index_training_translations_on_locale", using: :btree
  add_index "training_translations", ["training_id"], name: "index_training_translations_on_training_id", using: :btree

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
