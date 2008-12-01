# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

  create_table "articles", :force => true do |t|
    t.integer  "author_id",    :null => false
    t.string   "title",        :null => false
    t.text     "introduction", :null => false
    t.text     "body",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "commented_id",   :null => false
    t.string   "commented_type", :null => false
    t.string   "name",           :null => false
    t.string   "homepage"
    t.string   "email"
    t.text     "body",           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commented_id", "commented_type"], :name => "index_comments_on_commented_id_and_commented_type"

  create_table "logins", :force => true do |t|
    t.integer "user_id",                     :null => false
    t.string  "username",                    :null => false
    t.string  "password_salt", :limit => 10, :null => false
    t.string  "password_hash", :limit => 32, :null => false
  end

  add_index "logins", ["username"], :name => "index_logins_on_username", :unique => true

  create_table "onlists", :force => true do |t|
    t.integer  "onlisted_id",   :null => false
    t.string   "onlisted_type", :null => false
    t.boolean  "accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "onlists", ["onlisted_type", "onlisted_id"], :name => "index_onlists_on_onlisted_type_and_onlisted_id", :unique => true

  create_table "pages", :force => true do |t|
    t.string   "path",       :null => false
    t.string   "title",      :null => false
    t.text     "body",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["path"], :name => "index_pages_on_path", :unique => true

  create_table "project_roles", :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.boolean "lead"
    t.string  "description", :null => false
  end

  add_index "project_roles", ["project_id", "user_id"], :name => "index_project_roles_on_project_id_and_user_id", :unique => true

  create_table "projects", :force => true do |t|
    t.string "name",         :null => false
    t.string "homepage"
    t.text   "introduction", :null => false
    t.text   "description",  :null => false
  end

  create_table "slugs", :force => true do |t|
    t.integer  "sluggable_id"
    t.string   "sluggable_type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slugs", ["name", "sluggable_type"], :name => "index_slugs_on_name_and_sluggable_type", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "users", :force => true do |t|
    t.string "name",  :null => false
    t.string "email", :null => false
  end

end
