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

ActiveRecord::Schema.define(version: 20150408162754) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "marty_api_auths", force: :cascade do |t|
    t.integer  "group_id",     null: false
    t.datetime "created_dt",   null: false
    t.datetime "obsoleted_dt", null: false
    t.integer  "user_id",      null: false
    t.integer  "o_user_id"
    t.string   "app_name"
    t.string   "api_key"
    t.string   "script_name"
  end

  add_index "marty_api_auths", ["api_key", "script_name", "obsoleted_dt"], name: "unique_marty_api_auths", unique: true, using: :btree
  add_index "marty_api_auths", ["app_name", "script_name", "obsoleted_dt"], name: "unique_marty_api_auths_2", unique: true, using: :btree

  create_table "marty_demo_configs", force: :cascade do |t|
    t.string "key"
    t.string "value"
  end

  add_index "marty_demo_configs", ["key"], name: "index_marty_demo_configs_on_key", unique: true, using: :btree

  create_table "marty_import_types", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                null: false
    t.string   "db_model_name",       null: false
    t.string   "synonym_fields"
    t.string   "cleaner_function"
    t.string   "validation_function"
    t.integer  "role_id"
  end

  create_table "marty_posting_types", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "marty_postings", force: :cascade do |t|
    t.integer  "group_id",        null: false
    t.datetime "created_dt",      null: false
    t.datetime "obsoleted_dt",    null: false
    t.integer  "user_id",         null: false
    t.integer  "o_user_id"
    t.string   "name",            null: false
    t.integer  "posting_type_id", null: false
    t.string   "comment",         null: false
  end

  add_index "marty_postings", ["created_dt"], name: "index_marty_postings_on_created_dt", using: :btree
  add_index "marty_postings", ["name"], name: "index_marty_postings_on_name", using: :btree
  add_index "marty_postings", ["obsoleted_dt"], name: "index_marty_postings_on_obsoleted_dt", using: :btree
  add_index "marty_postings", ["posting_type_id"], name: "index_marty_postings_on_posting_type_id", using: :btree

  create_table "marty_promises", force: :cascade do |t|
    t.string   "title",     null: false
    t.integer  "user_id"
    t.string   "cformat"
    t.integer  "parent_id"
    t.integer  "job_id"
    t.boolean  "status"
    t.binary   "result"
    t.datetime "start_dt"
    t.datetime "end_dt"
  end

  add_index "marty_promises", ["parent_id"], name: "index_marty_promises_on_parent_id", using: :btree

  create_table "marty_roles", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "marty_scripts", force: :cascade do |t|
    t.integer  "group_id",     null: false
    t.datetime "created_dt",   null: false
    t.datetime "obsoleted_dt", null: false
    t.integer  "user_id",      null: false
    t.integer  "o_user_id"
    t.string   "name",         null: false
    t.text     "body",         null: false
    t.string   "version",      null: false
    t.text     "logmsg",       null: false
  end

  add_index "marty_scripts", ["created_dt"], name: "index_marty_scripts_on_created_dt", using: :btree
  add_index "marty_scripts", ["name"], name: "index_marty_scripts_on_name", using: :btree
  add_index "marty_scripts", ["obsoleted_dt"], name: "index_marty_scripts_on_obsoleted_dt", using: :btree

  create_table "marty_tags", force: :cascade do |t|
    t.integer  "group_id",     null: false
    t.datetime "created_dt",   null: false
    t.datetime "obsoleted_dt", null: false
    t.integer  "user_id",      null: false
    t.integer  "o_user_id"
    t.string   "name",         null: false
    t.string   "comment",      null: false
  end

  add_index "marty_tags", ["created_dt"], name: "index_marty_tags_on_created_dt", using: :btree
  add_index "marty_tags", ["name"], name: "index_marty_tags_on_name", using: :btree
  add_index "marty_tags", ["obsoleted_dt"], name: "index_marty_tags_on_obsoleted_dt", using: :btree

  create_table "marty_tokens", force: :cascade do |t|
    t.integer  "user_id",                 null: false
    t.string   "value",      default: "", null: false
    t.datetime "created_on",              null: false
  end

  add_index "marty_tokens", ["user_id"], name: "index_marty_tokens_on_user_id", using: :btree

  create_table "marty_user_roles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
  end

  add_index "marty_user_roles", ["user_id"], name: "index_marty_user_roles_on_user_id", using: :btree

  create_table "marty_users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login",      null: false
    t.string   "firstname",  null: false
    t.string   "lastname",   null: false
    t.boolean  "active",     null: false
    t.integer  "uuid"
  end

  add_foreign_key "marty_import_types", "marty_roles", column: "role_id", name: "fk_marty_import_types_marty_roles_role_id"
  add_foreign_key "marty_postings", "marty_posting_types", column: "posting_type_id", name: "fk_marty_postings_marty_posting_types_posting_type_id"
  add_foreign_key "marty_promises", "marty_promises", column: "parent_id", name: "fk_marty_promises_marty_promises_parent_id"
  add_foreign_key "marty_promises", "marty_users", column: "user_id", name: "fk_marty_promises_marty_users_user_id"
  add_foreign_key "marty_tokens", "marty_users", column: "user_id", name: "fk_marty_tokens_marty_users_user_id"
  add_foreign_key "marty_user_roles", "marty_roles", column: "role_id", name: "fk_marty_user_roles_marty_roles_role_id"
  add_foreign_key "marty_user_roles", "marty_users", column: "user_id", name: "fk_marty_user_roles_marty_users_user_id"
end
