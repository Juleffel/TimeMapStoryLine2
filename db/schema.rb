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

ActiveRecord::Schema.define(version: 20160405171129) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "character_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "answers", ["character_id"], name: "index_answers_on_character_id", using: :btree
  add_index "answers", ["topic_id"], name: "index_answers_on_topic_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "categories", force: true do |t|
    t.integer  "category_id"
    t.text     "title"
    t.text     "description"
    t.text     "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "permission_level"
    t.integer  "num"
    t.text     "special"
    t.boolean  "is_rpg"
    t.boolean  "is_flood"
  end

  add_index "categories", ["category_id"], name: "index_categories_on_category_id", using: :btree
  add_index "categories", ["special"], name: "index_categories_on_special", using: :btree

  create_table "characters", force: true do |t|
    t.integer  "user_id"
    t.text     "first_name"
    t.text     "last_name"
    t.date     "birth_date"
    t.text     "birth_place"
    t.boolean  "sex"
    t.text     "avatar_url"
    t.text     "avatar_name"
    t.text     "copyright"
    t.integer  "topic_id"
    t.text     "story"
    t.text     "anecdote"
    t.text     "test_rp"
    t.text     "psychology"
    t.text     "appearance"
    t.integer  "faction_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "image_url"
    t.text     "summary"
    t.text     "quote"
    t.text     "middle_name"
    t.text     "nickname"
    t.text     "small_image_url"
    t.text     "shortline1"
    t.text     "shortline2"
    t.integer  "links_topic_id"
    t.integer  "rps_topic_id"
    t.datetime "map_nodes_updated_at"
    t.boolean  "npc",                  default: false
  end

  add_index "characters", ["faction_id"], name: "index_characters_on_faction_id", using: :btree
  add_index "characters", ["group_id"], name: "index_characters_on_group_id", using: :btree
  add_index "characters", ["links_topic_id"], name: "index_characters_on_links_topic_id", using: :btree
  add_index "characters", ["rps_topic_id"], name: "index_characters_on_rps_topic_id", using: :btree
  add_index "characters", ["topic_id"], name: "index_characters_on_topic_id", using: :btree
  add_index "characters", ["user_id"], name: "index_characters_on_user_id", using: :btree

  create_table "factions", force: true do |t|
    t.text     "name"
    t.text     "description"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.text     "name"
    t.text     "description"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "special"
    t.boolean  "no_modif",      default: false
    t.boolean  "only_admin",    default: false
    t.boolean  "default_group", default: false
  end

  add_index "groups", ["special"], name: "index_groups_on_special", using: :btree

  create_table "link_natures", force: true do |t|
    t.text     "name"
    t.text     "description"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", force: true do |t|
    t.integer  "from_character_id"
    t.integer  "to_character_id"
    t.text     "title"
    t.text     "description"
    t.integer  "force"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "link_nature_id"
  end

  add_index "links", ["from_character_id"], name: "index_links_on_from_character_id", using: :btree
  add_index "links", ["link_nature_id"], name: "index_links_on_link_nature_id", using: :btree
  add_index "links", ["to_character_id"], name: "index_links_on_to_character_id", using: :btree

  create_table "presences", force: true do |t|
    t.integer  "character_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "spacetime_position_id"
  end

  add_index "presences", ["character_id"], name: "index_presences_on_character_id", using: :btree
  add_index "presences", ["spacetime_position_id"], name: "index_presences_on_spacetime_position_id", using: :btree

  create_table "rp_statuses", force: true do |t|
    t.text     "name"
    t.text     "description"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "display_last"
    t.integer  "num"
  end

  create_table "spacetime_positions", force: true do |t|
    t.float    "longitude"
    t.float    "latitude"
    t.text     "title"
    t.text     "subtitle"
    t.text     "resume"
    t.text     "weather"
    t.datetime "begin_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "birth"
  end

  add_index "spacetime_positions", ["user_id"], name: "index_spacetime_positions_on_user_id", using: :btree

  create_table "topics", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "spacetime_position_id"
    t.integer  "category_id"
    t.text     "image_url"
    t.text     "title"
    t.text     "subtitle"
    t.text     "summary"
    t.text     "weather"
    t.integer  "rp_status_id"
  end

  add_index "topics", ["category_id"], name: "index_topics_on_category_id", using: :btree
  add_index "topics", ["rp_status_id"], name: "index_topics_on_rp_status_id", using: :btree
  add_index "topics", ["spacetime_position_id"], name: "index_topics_on_spacetime_position_id", using: :btree
  add_index "topics", ["user_id"], name: "index_topics_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "pseudo"
    t.string   "role"
    t.string   "xmpp_password"
    t.boolean  "xmpp_valid",             default: false
    t.datetime "last_avatar_date"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
