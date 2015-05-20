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

ActiveRecord::Schema.define(version: 20150514064320) do

  create_table "article_authors", force: :cascade do |t|
    t.integer  "article_id", limit: 4
    t.integer  "author_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "article_authors", ["article_id"], name: "index_article_authors_on_article_id", using: :btree
  add_index "article_authors", ["author_id"], name: "index_article_authors_on_author_id", using: :btree

  create_table "article_terms", force: :cascade do |t|
    t.integer  "article_id", limit: 4
    t.integer  "term_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "article_terms", ["article_id"], name: "index_article_terms_on_article_id", using: :btree
  add_index "article_terms", ["term_id"], name: "index_article_terms_on_term_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "author_relations", force: :cascade do |t|
    t.integer  "author_id",         limit: 4
    t.integer  "related_author_id", limit: 4
    t.float    "weight",            limit: 24
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "author_terms", force: :cascade do |t|
    t.integer  "author_id",  limit: 4
    t.integer  "term_id",    limit: 4
    t.float    "weight",     limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "author_terms", ["author_id"], name: "index_author_terms_on_author_id", using: :btree
  add_index "author_terms", ["term_id"], name: "index_author_terms_on_term_id", using: :btree

  create_table "authors", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "stripped",    limit: 255
    t.string   "section",     limit: 255
    t.string   "sub_section", limit: 255
    t.date     "birthday"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "term_relations", force: :cascade do |t|
    t.integer  "term_id",         limit: 4
    t.integer  "related_term_id", limit: 4
    t.float    "weight",          limit: 24
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "terms", force: :cascade do |t|
    t.string   "term",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "article_authors", "articles"
  add_foreign_key "article_authors", "authors"
  add_foreign_key "article_terms", "articles"
  add_foreign_key "article_terms", "terms"
  add_foreign_key "author_terms", "authors"
  add_foreign_key "author_terms", "terms"
end
