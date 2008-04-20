class SetupAuthentification < ActiveRecord::Migration
  
  def self.create_user(name, username = nil, email = nil)
    username  ||= name.underscore
    email     ||= "#{ name } <#{ username }@localhost>"
    
    user = User.
      create :name => name, :email => email
    
    login = user.build_login
    STDERR.puts '=' * 20
    STDERR.puts "Username: #{ login.username = username }"
    STDERR.puts "Password: #{ login.password = Login.generate_password }"
    STDERR.puts '=' * 20
    login.sync_passwords
    
    login.save || raise('User could not be created!')
  end
  
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
    
    create_user ENV['NAME'] || 'Initial User', ENV['USER'], ENV['EMAIL']
  end
  
  def self.down
    drop_table :logins
    drop_table :users
  end
  
end
