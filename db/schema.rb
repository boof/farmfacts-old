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

ActiveRecord::Schema.define(:version => 6) do

  create_table "articles", :force => true do |t|
    t.string   "title",            :null => false
    t.text     "content_markdown", :null => false
    t.text     "head"
    t.text     "body"
    t.integer  "author_id",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "commented_type",                   :null => false
    t.integer  "commented_id",                     :null => false
    t.string   "author_name",                      :null => false
    t.string   "homepage"
    t.string   "email"
    t.boolean  "visible",        :default => true
    t.text     "body",                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commented_id", "commented_type"], :name => "index_comments_on_commented_id_and_commented_type", :unique => true

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
    t.integer  "user_id",                            :null => false
    t.integer  "publishable_id",                     :null => false
    t.string   "publishable_type"
    t.boolean  "revoked",          :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publications", ["publishable_id", "publishable_type"], :name => "index_publications_on_publishable_id_and_publishable_type", :unique => true

  create_table "users", :force => true do |t|
    t.string "name",  :null => false
    t.string "email", :null => false
  end

end
