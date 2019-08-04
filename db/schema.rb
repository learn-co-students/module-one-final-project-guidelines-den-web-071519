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

ActiveRecord::Schema.define(version: 2019_08_01_161720) do

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "health", default: 100, null: false
    t.integer "level", default: 0, null: false
  end

  create_table "players_spells", force: :cascade do |t|
    t.integer "spell_id"
    t.integer "player_id"
  end

  create_table "players_weapons", force: :cascade do |t|
    t.integer "weapon_id"
    t.integer "player_id"
  end

  create_table "saved_profiles", force: :cascade do |t|
    t.string "name"
    t.string "bio"
    t.string "password"
    t.integer "level", default: 1, null: false
  end

  create_table "spells", force: :cascade do |t|
    t.string "name"
    t.integer "health"
    t.integer "damage"
  end

  create_table "weapons", force: :cascade do |t|
    t.string "name"
    t.integer "damage"
  end

end
