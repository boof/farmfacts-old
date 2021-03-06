class Core < ActiveRecord::Migration

    def self.up
      create_table :users do |t|
        t.references :page
        t.string :name, :null => false
        t.string :email
        t.string :url
      end

      create_table :logins do |t|
        t.references :user, :null => false
        t.string :username, :null => false
        t.string :password_salt, :limit => 10, :null => false
        t.string :password_hash, :limit => 32, :null => false
      end
      add_index :logins, :username, :unique => true

      create_table :pages do |t|
        t.string :disposition, :default => 'Page'
        t.string :name, :null => false
        t.string :locale, :limit => 2
        t.string :path, :null => false
        t.string :doctype
        t.text :head
        t.text :body, :null => false
        t.timestamps
      end
      add_index :pages, :path, :unique => true
      create_table :pagifications do |t|
        t.references :page
        t.references :pagified, :polymorphic => true
      end
      add_index :pagifications, [:pagified_type, :pagified_id], :unique => true

      create_table :attachments do |t|
        t.references :attaching, :polymorphic => true, :null => false
        t.integer :position
        t.string :type
        t.string :public_id, :limit => 32

        t.string :attachable_file_name
        t.string :attachable_content_type
        t.integer :attachable_file_size
        t.timestamp :attachable_updated_at

        t.string :disposition
      end
      add_index :attachments, [:attaching_id, :attaching_type]
      add_index :attachments, [:type]

      create_table :onlists do |t|
        t.references :onlisted, :null => false, :polymorphic => true
        t.boolean :accepted
        t.timestamps
      end
      add_index :onlists, [:onlisted_type, :onlisted_id], :unique => true

      create_table :registered_paths do |t|
        t.references :provider, :polymorphic => true, :null => false

        t.string :scope
        t.string :label
        t.string :path
      end
      add_index :registered_paths, :scope
      add_index :registered_paths, :path, :unique => true
      add_index :registered_paths, [:provider_type, :provider_id], :unique => true

      create_table :categorizable_categories do |t|
        t.string :name, :null => false
        t.integer :categorizations_count
        t.timestamps
      end
      add_index :categorizable_categories, :name, :unique => true
      create_table :categorizable_categorizations do |t|
        t.references :category, :null => false
        t.references :categorizable, :polymorphic => true, :null => false
        t.timestamps
      end
      add_index :categorizable_categorizations, :category_id
      add_index :categorizable_categorizations, [:categorizable_id, :categorizable_type], :name => 'categorizable_polymorphmic'
      add_index :categorizable_categorizations, [:category_id, :categorizable_id, :categorizable_type], :unique => true, :name => 'categorizable_polymorphmic_category'

      create_table :navigations do |t|
        t.integer :parent_id
        t.integer :lft
        t.integer :rgt
        t.string :path
        t.string :label
        t.string :locale
        t.boolean :blank
        t.references :registered_path
      end
      add_index :navigations, :path
      add_index :navigations, :locale
      add_index :navigations, :parent_id

      create_table :themes do |t|
        t.string :name, :null => false
        t.string :caption, :null => false
        t.string :doctype, :null => false
        t.timestamps
      end
      add_index :themes, :name, :unique => true

      create_table :themed_pages do |t|
        t.string :name, :null => false
        t.string :title, :null => false
        t.references :theme
        t.text :metadata
        t.timestamps
      end
      create_table :themed_page_elements do |t|
        t.references :themed_page, :null => false
        t.string :path, :null => false
        t.text :data
        t.integer :position
        t.timestamps
      end
      add_index :themed_page_elements, :themed_page_id
    end

    def self.down
      drop_table :themed_page_elements
      drop_table :themed_pages
      drop_table :themes
      drop_table :navigations
      drop_table :categorizable_categorizations
      drop_table :categorizable_categories
      drop_table :registered_paths
      drop_table :onlists
      drop_table :attachments
      drop_table :pagifications
      drop_table :pages
      drop_table :logins
      drop_table :users
    end

end
