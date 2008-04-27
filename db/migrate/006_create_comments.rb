class CreateComments < ActiveRecord::Migration
  
  def self.up
    create_table :comments do |t|
      t.string :commented_type, :null => false
      t.integer :commented_id, :null => false
      
      t.string :author_name, :null => false
      t.string :homepage
      t.string :email
      
      t.boolean :visible, :default => true
      t.text :body, :null => false
      
      t.timestamps
    end
    
    add_index :comments, [:commented_id, :commented_type]
  end
  
  def self.down
    drop_table :comments
  end
  
end
