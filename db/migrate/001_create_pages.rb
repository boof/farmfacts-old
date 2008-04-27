class CreatePages < ActiveRecord::Migration
  
  CWD = File.dirname __FILE__
  
  def self.create_page(name, title)
    page = Page.new do |page|
      page.name = name
      page.title = title
      
      page.body_markdown = File.read File.join(CWD, "#{name}.markdown")
    end
    
    page.save || raise("Page #{ name } could not be created!")
  end
  
  def self.up
    create_table :pages do |t|
      t.string :name, :null => false
      t.string :title, :null => false
      t.text :body_markdown, :null => false
      t.text :body
      
      t.integer :comments_count, :default => 0
      
      t.timestamps
    end
    add_index :pages, :name, :unique => true
    
    create_page 'home', 'Ruby Sequel - The Database Toolkit for Ruby'
    create_page 'not_found', '404 - Page not found!'
    
    create_page 'documentation', 'Ruby Sequel Documentation'
    create_page 'documentation/getting_started',
                'Getting Started with Ruby Sequel'
    create_page 'documentation/models',
                'Ruby Sequel Documentation on Models'
    
    create_page 'community', 'Ruby Sequel Community'
    
    create_page 'deprecation/1-5', 'Ruby Sequel 1.5 Deprecation'
    create_page 'website-todo', 'Ruby Sequel - Website TODOs'
  end
  
  def self.down
    drop_table :pages
  end
  
end
