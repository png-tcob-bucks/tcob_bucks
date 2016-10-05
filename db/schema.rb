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

ActiveRecord::Schema.define(version: 20160930010922) do

  create_table "buck_logs", force: :cascade do |t|
    t.integer  "buck_id",       limit: 4,   null: false
    t.string   "event",         limit: 255, null: false
    t.integer  "performed_id",  limit: 4,   null: false
    t.integer  "recieved_id",   limit: 4,   null: false
    t.string   "status_before", limit: 255, null: false
    t.string   "status_after",  limit: 255, null: false
    t.integer  "value_before",  limit: 4
    t.integer  "value_after",   limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "purchase_id",   limit: 4
  end

  add_index "buck_logs", ["buck_id"], name: "index_buck_logs_on_buck_id", using: :btree
  add_index "buck_logs", ["performed_id"], name: "index_buck_logs_on_performed_id", using: :btree
  add_index "buck_logs", ["recieved_id"], name: "index_buck_logs_on_recieved_id", using: :btree

  create_table "bucks", force: :cascade do |t|
    t.integer  "number",        limit: 4,     null: false
    t.integer  "employee_id",   limit: 4,     null: false
    t.integer  "value",         limit: 4,     null: false
    t.string   "status",        limit: 255
    t.integer  "assignedBy",    limit: 4,     null: false
    t.integer  "department_id", limit: 4,     null: false
    t.string   "reason_short",  limit: 255
    t.text     "reason_long",   limit: 65535
    t.datetime "expires"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.datetime "approved_at"
  end

  add_index "bucks", ["assignedBy"], name: "index_bucks_on_assignedBy", using: :btree
  add_index "bucks", ["employee_id"], name: "index_bucks_on_employee_id", using: :btree
  add_index "bucks", ["number"], name: "index_bucks_on_number", using: :btree

  create_table "departments", force: :cascade do |t|
    t.string  "name",     limit: 255
    t.integer "budget",   limit: 4,   default: 0
    t.string  "approve1", limit: 255
    t.string  "approve2", limit: 255
  end

  create_table "employees", force: :cascade do |t|
    t.integer  "IDnum",           limit: 4,               null: false
    t.string   "first_name",      limit: 255
    t.string   "last_name",       limit: 255
    t.integer  "department_id",   limit: 4,               null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "password_digest", limit: 255
    t.string   "job_id",          limit: 255,             null: false
    t.string   "email",           limit: 255
    t.string   "status",          limit: 255
    t.integer  "balance",         limit: 4,   default: 0
    t.integer  "earned_m",        limit: 4,   default: 0
  end

  add_index "employees", ["IDnum"], name: "index_employees_on_IDnum", using: :btree
  add_index "employees", ["first_name"], name: "index_employees_on_first_name", using: :btree
  add_index "employees", ["job_id"], name: "index_employees_on_job_id", using: :btree
  add_index "employees", ["last_name"], name: "index_employees_on_last_name", using: :btree

  create_table "favorites", force: :cascade do |t|
    t.integer  "employee_id", limit: 4, null: false
    t.integer  "prize_id",    limit: 4, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "favorites", ["employee_id"], name: "index_favorites_on_employee_id", using: :btree
  add_index "favorites", ["prize_id"], name: "index_favorites_on_prize_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.string   "jobcode",    limit: 255, null: false
    t.string   "title",      limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "job_id",     limit: 255, null: false
    t.integer  "role_id",    limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "permissions", ["job_id"], name: "index_permissions_on_job_id", using: :btree
  add_index "permissions", ["role_id"], name: "index_permissions_on_role_id", using: :btree

  create_table "prize_subcats", force: :cascade do |t|
    t.integer  "prize_id",     limit: 4,                 null: false
    t.integer  "stock",        limit: 4,     default: 0
    t.datetime "last_counted"
    t.string   "size",         limit: 255
    t.string   "color",        limit: 255
    t.text     "image",        limit: 65535
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "brand",        limit: 255
  end

  add_index "prize_subcats", ["prize_id"], name: "index_prize_subcats_on_prize_id", using: :btree

  create_table "prizes", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "cost",        limit: 4
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.text     "description", limit: 65535
    t.boolean  "must_order"
    t.boolean  "available",                 default: true,                   null: false
    t.string   "image",       limit: 255,   default: "/images/no_image.png"
    t.boolean  "featured",                  default: false
  end

  add_index "prizes", ["id"], name: "index_prizes_on_id_and_itemID", unique: true, using: :btree

  create_table "purchases", force: :cascade do |t|
    t.integer  "prize_id",        limit: 4,                   null: false
    t.integer  "employee_id",     limit: 4
    t.integer  "cashier_id",      limit: 4
    t.string   "status",          limit: 255
    t.boolean  "exchanged",                   default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "pickedup_by",     limit: 4
    t.integer  "prize_subcat_id", limit: 4
    t.boolean  "returned",                    default: false
  end

  add_index "purchases", ["prize_id"], name: "index_purchases_on_prize_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string  "title",      limit: 255,                 null: false
    t.boolean "issue",                  default: false, null: false
    t.boolean "approve",                default: false, null: false
    t.boolean "redeem",                 default: false, null: false
    t.boolean "admin",                  default: false, null: false
    t.boolean "view_all",               default: false, null: false
    t.boolean "recieve",                default: false, null: false
    t.boolean "view_dept",              default: false, null: false
    t.boolean "issue_gold",             default: false, null: false
    t.boolean "inventory",              default: false, null: false
    t.boolean "access",                 default: false
    t.boolean "feedback",               default: false
  end

  create_table "store_logs", force: :cascade do |t|
    t.integer  "employee_id",     limit: 4,   null: false
    t.string   "cashier_id",      limit: 255, null: false
    t.integer  "stock_before",    limit: 4
    t.integer  "stock_after",     limit: 4
    t.string   "trans",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "purchase_id",     limit: 4
    t.integer  "prize_id",        limit: 4
    t.integer  "prize_subcat_id", limit: 4
  end

  add_index "store_logs", ["cashier_id"], name: "index_store_logs_on_cashier_id", using: :btree
  add_index "store_logs", ["employee_id"], name: "index_store_logs_on_employee_id", using: :btree
  add_index "store_logs", ["prize_id"], name: "index_store_logs_on_prize_id", using: :btree
  add_index "store_logs", ["purchase_id"], name: "index_store_logs_on_purchase_id", using: :btree

  add_foreign_key "store_logs", "prizes"
  add_foreign_key "store_logs", "purchases"
end
