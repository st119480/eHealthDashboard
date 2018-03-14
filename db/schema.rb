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

ActiveRecord::Schema.define(version: 20180314132818) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blood_types", force: :cascade do |t|
    t.string "blood_group_rh_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doctors", force: :cascade do |t|
    t.string "license_num", default: "", null: false
    t.string "qualification", default: ""
    t.bigint "user_id"
    t.bigint "specialty_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["specialty_id"], name: "index_doctors_on_specialty_id"
    t.index ["user_id"], name: "index_doctors_on_user_id"
  end

  create_table "patients", force: :cascade do |t|
    t.bigint "blood_type_id"
    t.bigint "user_id"
    t.string "created_at"
    t.string "updated_at"
    t.index ["blood_type_id"], name: "index_patients_on_blood_type_id"
    t.index ["user_id"], name: "index_patients_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specialties", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "username", default: "", null: false
    t.date "dob", null: false
    t.string "contact", default: ""
    t.string "province", default: ""
    t.string "city_village", default: ""
    t.string "address_line_1", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "role_id"
    t.string "gender"
    t.integer "actable_id"
    t.string "actable_type"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "doctors", "specialties"
  add_foreign_key "doctors", "users"
  add_foreign_key "patients", "blood_types"
  add_foreign_key "patients", "users"
  add_foreign_key "users", "roles"
end
