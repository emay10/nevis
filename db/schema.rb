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

ActiveRecord::Schema.define(version: 20160711113148) do

  create_table "agencies", force: :cascade do |t|
    t.string   "name"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.integer  "quantity",       default: 1, null: false
    t.integer  "policy_id"
    t.integer  "user_id"
    t.integer  "status",         default: 1, null: false
    t.text     "notes"
    t.date     "effective_date"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "clients", ["policy_id"], name: "index_clients_on_policy_id"
  add_index "clients", ["user_id"], name: "index_clients_on_user_id"

  create_table "commissions", force: :cascade do |t|
    t.integer "client_id"
    t.date    "statement_date"
    t.date    "earned_date"
    t.integer "commission"
  end

  add_index "commissions", ["client_id"], name: "index_commissions_on_client_id"

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "policies", force: :cascade do |t|
    t.string   "name"
    t.string   "carrier"
    t.integer  "kind"
    t.integer  "commission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statements", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "date"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "status",     default: false, null: false
  end

  add_index "statements", ["user_id"], name: "index_statements_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string  "email",           default: "", null: false
    t.string  "password_digest", default: "", null: false
    t.integer "agency_id"
    t.integer "commission"
    t.integer "role",            default: 0,  null: false
    t.string  "name"
  end

  add_index "users", ["agency_id"], name: "index_users_on_agency_id"
  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
