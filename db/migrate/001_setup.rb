class Setup < ActiveRecord::Migration

  def self.up
    create_table :users do |t|
      t.string :name, :null => false
      t.string :email, :null => false
    end

    create_table :logins do |t|
      t.references :user, :null => false

      t.string :username, :null => false
      t.string :password_salt, :limit => 10, :null => false
      t.string :password_hash, :limit => 32, :null => false
    end
    add_index :logins, :username, :unique => true

    create_table :onlists do |t|
      t.references :onlisted, :null => false, :polymorphic => true

      t.boolean :accepted

      t.timestamps
    end
    add_index :onlists, [:onlisted_type, :onlisted_id], :unique => true

    create_table :comments do |t|
      t.references :commented, :polymorphic => true, :null => false

      t.string :name, :null => false
      t.string :homepage
      t.string :email
      t.text :body, :null => false

      t.timestamps
    end
    add_index :comments, [:commented_id, :commented_type]

    create_table :pages do |t|
      t.string :path, :null => false
      t.string :title, :null => false
      t.text :body, :null => false

      t.timestamps
    end
    add_index :pages, :path, :unique => true

    create_table :articles do |t|
      t.references :author, :null => false

      t.string :title, :null => false
      t.text :introduction, :null => false
      t.text :body, :null => false

      t.timestamps
    end

    create_table :projects do |t|
      t.string :name, :null => false
      t.string :homepage
      t.text :introduction, :null => false
      t.text :description, :null => false
    end

    create_table :project_roles do |t|
      t.references :project
      t.references :user

      t.boolean :lead
      t.string :description, :null => false
    end
    add_index :project_roles, [:project_id, :user_id], :unique => true

    create_table :slugs do |t|
      t.references :sluggable, :polymorphic => true

      t.string :name

      t.timestamps
    end
    add_index :slugs, [:name, :sluggable_type], :unique
    add_index :slugs, :sluggable_id
  end

  def self.down
    drop_table :slugs
    drop_table :project_roles
    drop_table :projects
    drop_table :articles
    drop_table :pages
    drop_table :comments
    drop_table :onlists
    drop_table :logins
    drop_table :users
  end

end
