class Core < ActiveRecord::Migration

    def self.up
      create_table :users do |t|
        t.references :page
        t.string :name, :null => false
        t.string :email
        t.string :url
        t.string :github_user
      end

      create_table :logins do |t|
        t.references :user, :null => false
        t.string :username, :null => false
        t.string :password_salt, :limit => 10, :null => false
        t.string :password_hash, :limit => 32, :null => false
      end
      add_index :logins, :username, :unique => true

      create_table :pages do |t|
        t.string :path, :null => false
        # TODO: Move this into model/controller.
        t.text :head #, :default => {}
        t.text :body, :null => false
        t.string :title, :null => false
        t.string :summary
        t.timestamps
      end
      add_index :pages, :path, :unique => true

      create_table :navigation_containers do |t|
        t.string :element_id, :null => false
        # TODO: Move this into model/controller.
        t.text :html_attributes #, :default => {'class' => 'navigation'}
        t.timestamps
      end
      add_index :navigation_containers, :element_id, :unique => true

      create_table :navigation_nodes do |t|
        t.references :container, :null => false
        t.references :registered_path
        t.integer :position, :default => 0
        t.string :html_class, :default => 'column'
        t.string :content, :null => false
        t.string :url
        t.timestamps
      end
      add_index :navigation_nodes, :registered_path_id

      create_table :attachments do |t|
        t.references :attaching, :polymorphic => true, :null => false
        t.string :attachable_file_name
        t.string :attachable_content_type
        t.integer :attachable_file_size
        t.timestamp :attachable_updated_at
      end
      add_index :attachments, [:attaching_id, :attaching_type]

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
        t.string :slug, :null => false
        t.string :icon_file_name
        t.string :icon_content_type
        t.timestamp :icon_updated_at
        t.integer :icon_file_size
        t.timestamps
      end
      add_index :categorizable_categories, :name, :unique => true
      create_table :categorizable_categorizations do |t|
        t.references :category, :null => false
        t.references :categorizable, :polymorphic => true, :null => false
        t.timestamps
      end
      add_index :categorizable_categorizations, :category_id
      add_index :categorizable_categorizations, [:categorizable_id, :categorizable_type]
      add_index :categorizable_categorizations, [:category_id, :categorizable_id, :categorizable_type], :unique => true
    end

    def self.down
      drop_table :categorizable_categorizations
      drop_table :categorizable_categories
      drop_table :registered_paths
      drop_table :onlists
      drop_table :attachments
      drop_table :navigation_nodes
      drop_table :navigation_containers
      drop_table :pages
      drop_table :logins
      drop_table :users
    end

end