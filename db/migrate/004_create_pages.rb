class CreatePages < ActiveRecord::Migration
  
  def self.up
    create_table :pages do |t|
      t.string :name, :null => false
      t.string :title, :null => false
      t.text :body
      
      t.timestamps
    end
    add_index :pages, :name, :unique => true
  end
  
  def self.down
    drop_table :pages
  end
  
end
