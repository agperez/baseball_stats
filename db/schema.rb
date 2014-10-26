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

ActiveRecord::Schema.define(version: 20141026120252) do

  create_table "leagues", force: true do |t|
    t.string "name"
  end

  create_table "players", force: true do |t|
    t.string   "first"
    t.string   "last"
    t.string   "importid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["importid"], name: "index_players_on_importid", unique: true

  create_table "season_stats", force: true do |t|
    t.integer  "games"
    t.integer  "ab"
    t.integer  "runs"
    t.integer  "hits"
    t.integer  "doubles"
    t.integer  "triples"
    t.integer  "hr"
    t.integer  "rbi"
    t.integer  "sb"
    t.integer  "cs"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "player_id"
    t.integer  "season_id"
    t.float    "avg"
  end

  add_index "season_stats", ["player_id"], name: "index_season_stats_on_player_id"
  add_index "season_stats", ["season_id"], name: "index_season_stats_on_season_id"

  create_table "seasons", force: true do |t|
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "seasons", ["year"], name: "index_seasons_on_year", unique: true

  create_table "statsheets", force: true do |t|
    t.integer  "games"
    t.integer  "ab"
    t.integer  "runs"
    t.integer  "hits"
    t.integer  "doubles"
    t.integer  "triples"
    t.integer  "hr"
    t.integer  "rbi"
    t.integer  "sb"
    t.integer  "cs"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "player_id"
    t.integer  "team_id"
    t.integer  "season_id"
    t.integer  "season_stat_id"
    t.integer  "league_id"
  end

  add_index "statsheets", ["league_id"], name: "index_statsheets_on_league_id"
  add_index "statsheets", ["player_id"], name: "index_statsheets_on_player_id"
  add_index "statsheets", ["season_id"], name: "index_statsheets_on_season_id"
  add_index "statsheets", ["season_stat_id"], name: "index_statsheets_on_season_stat_id"
  add_index "statsheets", ["team_id"], name: "index_statsheets_on_team_id"

  create_table "teams", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "league_id"
  end

end
