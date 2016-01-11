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

ActiveRecord::Schema.define(version: 20160111020859) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "incidents", force: :cascade do |t|
    t.text     "victim_name"
    t.integer  "victim_age"
    t.text     "victim_gender"
    t.text     "victim_race"
    t.text     "victim_image_url"
    t.date     "incident_date"
    t.text     "incident_street_address"
    t.text     "incident_city"
    t.text     "incident_state"
    t.text     "incident_zip"
    t.text     "incident_county"
    t.text     "agency_responsible"
    t.text     "cause_of_death"
    t.text     "alleged_victim_crime"
    t.text     "crime_category"
    t.text     "aggregate_crime_category"
    t.text     "caveat"
    t.text     "solution"
    t.text     "incident_description"
    t.text     "official_disposition_of_death"
    t.text     "criminal_charges"
    t.text     "news_url"
    t.text     "mental_illness"
    t.text     "unarmed"
    t.text     "line_of_duty"
    t.text     "note"
    t.text     "in_custody"
    t.text     "arrest_related_death"
    t.integer  "unique_mpv"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.decimal  "latitude",                           precision: 10, scale: 6
    t.decimal  "longitude",                          precision: 10, scale: 6
    t.text     "within_city_limits"
    t.text     "officers_involved"
    t.text     "race_of_officers_involved"
    t.text     "gender_of_officers_involved"
    t.text     "notes_related_to_officers_involved"
    t.integer  "sort_order"
    t.decimal  "unique_identifier"
    t.text     "suspect_weapon_type"
  end

  add_index "incidents", ["unique_mpv"], name: "index_incidents_on_unique_mpv", unique: true, using: :btree

  create_table "unique_mpv_seq", force: :cascade do |t|
    t.integer "last_value"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
