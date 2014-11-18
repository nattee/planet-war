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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20141118164206) do

  create_table "jail_users", :primary_key => "jail_user_id", :force => true do |t|
    t.integer "in_use",   :limit => 1,  :default => 0
    t.string  "username", :limit => 45
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.string   "pretty_name"
    t.string   "ext"
    t.string   "common_ext"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "maps", :force => true do |t|
    t.string   "map_file"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "matches", :force => true do |t|
    t.integer  "p1_sub_id"
    t.integer  "p2_sub_id"
    t.text     "log",        :limit => 16777215
    t.datetime "play_at"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "winner"
    t.integer  "state",                          :default => 0
    t.integer  "match_type",                     :default => 0
    t.integer  "map_id"
    t.string   "p1_err"
    t.string   "p2_err"
  end

  add_index "matches", ["p1_sub_id"], :name => "index_matches_on_p1_sub_id"
  add_index "matches", ["p2_sub_id"], :name => "index_matches_on_p2_sub_id"

  create_table "submissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "language_id"
    t.text     "code"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "state",            :default => 0
    t.string   "ip_address"
    t.string   "filename"
    t.text     "compiler_message"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "state",       :default => 0
    t.datetime "finished_at"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "priority",    :default => 0
    t.integer  "match_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login",           :limit => 50
    t.string   "full_name"
    t.string   "hashed_password"
    t.string   "salt",            :limit => 5
    t.string   "alias"
    t.string   "email"
    t.integer  "site_id"
    t.integer  "country_id"
    t.boolean  "activated",                     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
