class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string   "login",           :limit => 50
      t.string   "full_name"
      t.string   "hashed_password"
      t.string   "salt",            :limit => 5
      t.string   "alias"
      t.string   "email"
      t.integer  "site_id"
      t.integer  "country_id"
      t.boolean  "activated",                     :default => false
      t.timestamps
      #t.datetime "created_at"
      #t.datetime "updated_at"
    end

    add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  end
end
