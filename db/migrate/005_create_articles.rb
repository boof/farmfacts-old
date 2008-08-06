class CreateArticles < ActiveRecord::Migration
  
  def self.up
    create_table :articles do |t|
      t.string :title, :null => false
      t.text :head
      t.text :body
      
      t.references :author, :null => false
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :articles
  end
  
end
