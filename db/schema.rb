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

ActiveRecord::Schema[7.0].define(version: 2023_03_23_211523) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drivers", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "home_address", null: false
    t.string "home_coordinates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at", precision: nil
    t.index ["external_id"], name: "index_drivers_on_external_id"
    t.index ["home_address"], name: "index_drivers_on_home_address"
  end

  create_table "rides", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "start_address", null: false
    t.string "start_coordinates"
    t.string "destination_address", null: false
    t.string "destination_coordinates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "driver_id"
    t.datetime "deleted_at", precision: nil
    t.float "commute_distance"
    t.float "commute_duration"
    t.float "ride_distance"
    t.float "ride_duration"
    t.float "earnings"
    t.float "score"
    t.index ["destination_address"], name: "index_rides_on_destination_address"
    t.index ["driver_id"], name: "index_rides_on_driver_id"
    t.index ["external_id"], name: "index_rides_on_external_id"
    t.index ["start_address", "destination_address"], name: "index_rides_on_start_address_and_destination_address", unique: true
    t.index ["start_address"], name: "index_rides_on_start_address"
  end

  add_foreign_key "rides", "drivers"
end
