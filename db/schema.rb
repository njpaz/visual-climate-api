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

ActiveRecord::Schema.define(version: 20160227045537) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_categories", force: :cascade do |t|
    t.string   "identifier"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "data_set_id"
  end

  add_index "data_categories", ["identifier"], name: "index_data_categories_on_identifier", unique: true, using: :btree

  create_table "data_category_locations", force: :cascade do |t|
    t.integer  "data_category_id"
    t.integer  "location_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "data_category_stations", force: :cascade do |t|
    t.integer  "data_category_id"
    t.integer  "station_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "data_set_data_types", force: :cascade do |t|
    t.integer  "data_set_id"
    t.integer  "data_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_set_location_categories", force: :cascade do |t|
    t.integer  "location_category_id"
    t.integer  "data_set_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "data_set_locations", force: :cascade do |t|
    t.integer  "data_set_id"
    t.integer  "location_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "data_set_stations", force: :cascade do |t|
    t.integer  "data_set_id"
    t.integer  "station_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "data_sets", force: :cascade do |t|
    t.string   "identifier"
    t.decimal  "data_coverage"
    t.date     "min_date"
    t.date     "max_date"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "name"
  end

  add_index "data_sets", ["identifier"], name: "index_data_sets_on_identifier", unique: true, using: :btree

  create_table "data_type_stations", force: :cascade do |t|
    t.integer  "data_type_id"
    t.integer  "station_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "data_types", force: :cascade do |t|
    t.string   "identifier"
    t.integer  "data_coverage"
    t.date     "min_date"
    t.date     "max_date"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "name"
    t.integer  "data_category_id"
    t.integer  "location_id"
  end

  add_index "data_types", ["identifier"], name: "index_data_types_on_identifier", unique: true, using: :btree

  create_table "location_categories", force: :cascade do |t|
    t.string   "identifier"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "data_set_id"
  end

  add_index "location_categories", ["identifier"], name: "index_location_categories_on_identifier", unique: true, using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "identifier"
    t.string   "name"
    t.integer  "data_coverage"
    t.date     "min_date"
    t.date     "max_date"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "location_category_id"
  end

  add_index "locations", ["identifier"], name: "index_locations_on_identifier", unique: true, using: :btree

  create_table "stations", force: :cascade do |t|
    t.string   "identifier"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "name"
    t.string   "elevation_unit"
    t.integer  "data_coverage"
    t.date     "min_date"
    t.date     "max_date"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.decimal  "elevation"
    t.integer  "location_id"
  end

  add_index "stations", ["identifier"], name: "index_stations_on_identifier", unique: true, using: :btree

  create_table "weather_data", force: :cascade do |t|
    t.string   "data_attributes"
    t.integer  "data_set_id"
    t.integer  "data_type_id"
    t.integer  "station_id"
    t.integer  "value"
    t.date     "date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
