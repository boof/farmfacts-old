class CreateArticles < ActiveRecord::Migration
  
  def self.up
    create_table :articles do |t|
      t.string :title, :null => false
      t.text :content_markdown, :null => false
      t.text :head
      t.text :body
      
      t.integer :comments_count, :default => 0
      t.references :user, :null => false
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :articles
  end
  
end
