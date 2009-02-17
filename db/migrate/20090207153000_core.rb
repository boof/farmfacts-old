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
        t.string :type
        t.string :path, :null => false
        t.string :compiled_path, :null => false
        t.string :title, :null => false
        t.references :template
        t.text :metadata
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

      create_table :templates do |t|
        t.string :name, :null => false
        t.text :definition
        t.timestamps
      end
      create_table :page_elements do |t|
        t.references :templated_page
        t.string :snippet_path
        t.text :data
        t.integer :position
        t.timestamps
      end
      add_index :page_elements, :templated_page_id

#      create_table :navigation_containers do |t|
#        t.string :element_id, :null => false
#        t.text :html_attributes
#        t.timestamps
#      end
#      add_index :navigation_containers, :element_id, :unique => true
#
#      create_table :navigation_nodes do |t|
#        t.references :container, :null => false
#        t.references :registered_path
#        t.integer :position, :default => 0
#        t.string :html_class, :default => 'column'
#        t.string :content, :null => false
#        t.string :url
#        t.timestamps
#      end
#      add_index :navigation_nodes, :registered_path_id
    end

    def self.down
#      drop_table :navigation_nodes
#      drop_table :navigation_containers
      drop_table :page_elements
      drop_table :templates
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
