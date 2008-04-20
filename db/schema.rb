# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 5) do

  create_table "cached_feeds", :force => true do |t|
    t.string   "url"
    t.string   "href"
    t.string   "title"
    t.string   "link"
    t.text     "feed_data"
    t.string   "feed_data_type"
    t.text     "http_headers"
    t.datetime "last_retrieved"
  end

  add_index "cached_feeds", ["href"], :name => "index_cached_feeds_on_href", :unique => true

  create_table "logins", :force => true do |t|
    t.string  "username",                    :null => false
    t.string  "password_salt", :limit => 10, :null => false
    t.string  "password_hash", :limit => 32, :null => false
    t.integer "user_id",                     :null => false
  end

  add_index "logins", ["username"], :name => "index_logins_on_username", :unique => true

  create_table "pages", :force => true do |t|
    t.string   "name",          :null => false
    t.string   "title",         :null => false
    t.text     "body_markdown", :null => false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["name"], :name => "index_pages_on_name", :unique => true

  create_table "plugins", :force => true do |t|
    t.string "name",                 :null => false
    t.string "contributor_name"
    t.string "contributor_email"
    t.text   "description_markdown", :null => false
    t.text   "description"
    t.string "feed_path"
    t.string "documentation_path"
  end

  create_table "publications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "publishable_id"
    t.string   "publishable_type"
    t.boolean  "revoked"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string "name",  :null => false
    t.string "email", :null => false
  end

end
