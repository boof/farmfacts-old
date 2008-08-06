class SetupAuthentification < ActiveRecord::Migration
  
  def self.up
    create_table :users do |t|
      t.string :name, :null => false
      t.string :email, :null => false
    end
    
    create_table :logins do |t|
      t.string :username, :null => false
      t.string :password_salt, :limit => 10, :null => false
      t.string :password_hash, :limit => 32, :null => false
      t.references :user, :null => false
    end
    add_index :logins, :username, :unique => true
  end
  
  def self.down
    drop_table :logins
    drop_table :users
  end
  
end
