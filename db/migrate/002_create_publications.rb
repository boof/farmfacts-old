class CreatePublications < ActiveRecord::Migration
  
  def self.up
    create_table :publications do |t|
      t.references :editor, :null => false
      t.references :publishable, :polymorphic => true, :null => false
      
      t.timestamps
    end
    
    add_index :publications, [:publishable_id, :publishable_type],
      :unique => true
  end
  
  def self.down
    drop_table :publications
  end
  
end
