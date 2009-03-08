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

ActiveRecord::Schema.define(:version => 20090207153000) do

  create_table "attachments", :force => true do |t|
    t.integer  "attaching_id",                          :null => false
    t.string   "attaching_type",                        :null => false
    t.integer  "position"
    t.string   "type"
    t.string   "public_id",               :limit => 32
    t.string   "attachable_file_name"
    t.string   "attachable_content_type"
    t.integer  "attachable_file_size"
    t.datetime "attachable_updated_at"
    t.string   "disposition"
  end

  add_index "attachments", ["attaching_id", "attaching_type"], :name => "index_attachments_on_attaching_id_and_attaching_type"
  add_index "attachments", ["type"], :name => "index_attachments_on_type"

  create_table "categorizable_categories", :force => true do |t|
    t.string   "name",                  :null => false
    t.integer  "categorizations_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categorizable_categories", ["name"], :name => "index_categorizable_categories_on_name", :unique => true

  create_table "categorizable_categorizations", :force => true do |t|
    t.integer  "category_id",        :null => false
    t.integer  "categorizable_id",   :null => false
    t.string   "categorizable_type", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categorizable_categorizations", ["categorizable_id", "categorizable_type", "category_id"], :name => "categorizable_polymorphmic_category", :unique => true
  add_index "categorizable_categorizations", ["categorizable_id", "categorizable_type"], :name => "categorizable_polymorphmic"
  add_index "categorizable_categorizations", ["category_id"], :name => "index_categorizable_categorizations_on_category_id"

  create_table "logins", :force => true do |t|
    t.integer "user_id",                     :null => false
    t.string  "username",                    :null => false
    t.string  "password_salt", :limit => 10, :null => false
    t.string  "password_hash", :limit => 32, :null => false
  end

  add_index "logins", ["username"], :name => "index_logins_on_username", :unique => true

  create_table "navigations", :force => true do |t|
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.string  "path",               :null => false
    t.string  "label"
    t.string  "locale"
    t.boolean "blank"
    t.integer "registered_path_id"
  end

  create_table "onlists", :force => true do |t|
    t.integer  "onlisted_id",   :null => false
    t.string   "onlisted_type", :null => false
    t.boolean  "accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "onlists", ["onlisted_id", "onlisted_type"], :name => "index_onlists_on_onlisted_type_and_onlisted_id", :unique => true

  create_table "pages", :force => true do |t|
    t.string   "disposition",              :default => "Page"
    t.string   "name",                                         :null => false
    t.string   "locale",      :limit => 2
    t.string   "path",                                         :null => false
    t.string   "doctype"
    t.text     "head"
    t.text     "body",                                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["path"], :name => "index_pages_on_path", :unique => true

  create_table "pagifications", :force => true do |t|
    t.integer "page_id"
    t.integer "pagified_id"
    t.string  "pagified_type"
  end

  add_index "pagifications", ["pagified_id", "pagified_type"], :name => "index_pagifications_on_pagified_type_and_pagified_id", :unique => true

  create_table "registered_paths", :force => true do |t|
    t.integer "provider_id",   :null => false
    t.string  "provider_type", :null => false
    t.string  "scope"
    t.string  "label"
    t.string  "path"
  end

  add_index "registered_paths", ["path"], :name => "index_registered_paths_on_path", :unique => true
  add_index "registered_paths", ["provider_id", "provider_type"], :name => "index_registered_paths_on_provider_type_and_provider_id", :unique => true
  add_index "registered_paths", ["scope"], :name => "index_registered_paths_on_scope"

  create_table "themed_page_elements", :force => true do |t|
    t.integer  "themed_page_id", :null => false
    t.string   "path",           :null => false
    t.text     "data"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "themed_page_elements", ["themed_page_id"], :name => "index_themed_page_elements_on_themed_page_id"

  create_table "themed_pages", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "title",      :null => false
    t.integer  "theme_id"
    t.text     "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "themes", :force => true do |t|
    t.string   "name",                        :null => false
    t.string   "caption",                     :null => false
    t.string   "doctype",                     :null => false
    t.string   "navigation", :default => "f"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "themes", ["name"], :name => "index_themes_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.integer "page_id"
    t.string  "name",    :null => false
    t.string  "email"
    t.string  "url"
  end

end
