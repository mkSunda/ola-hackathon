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

ActiveRecord::Schema.define(version: 20150927001837) do

  create_table "cabs", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.integer  "base_fare",               limit: 4
    t.decimal  "cost_per_distance",                   precision: 10
    t.decimal  "waiting_cost_per_minute",             precision: 10
    t.decimal  "ride_cost_per_minute",                precision: 10
    t.decimal  "minimum_distance",                    precision: 10
    t.integer  "minimum_time",            limit: 4
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  create_table "location_histories", force: :cascade do |t|
    t.integer  "location_id",     limit: 4
    t.integer  "cab_id",          limit: 4
    t.integer  "eta",             limit: 4
    t.float    "distance",        limit: 24
    t.string   "type",            limit: 255
    t.string   "surcharge_type",  limit: 255
    t.float    "surcharge_value", limit: 24
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "pincode",    limit: 4
    t.decimal  "lat",                    precision: 10, scale: 8
    t.decimal  "lng",                    precision: 10, scale: 8
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  create_table "rides", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "location_id",   limit: 4
    t.integer  "crn",           limit: 4
    t.string   "driver_name",   limit: 255
    t.string   "driver_number", limit: 255
    t.string   "cab_type",      limit: 255
    t.string   "cab_number",    limit: 255
    t.string   "car_model",     limit: 255
    t.datetime "arrival_time"
    t.decimal  "driver_lat",                precision: 10
    t.decimal  "driver_lng",                precision: 10
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "scheduled_bookings", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "location_id", limit: 4
    t.datetime "pickup_time"
    t.string   "status",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "phone",      limit: 255
    t.string   "token",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
