class CreatePublications < ActiveRecord::Migration
  
  def self.up
    create_table :publications do |t|
      t.references :user, :null => false
      t.references :publishable, :polymorphic => true, :null => false
      
      t.boolean :revoked, :default => true
      
      t.timestamps
    end
    
    add_index :publications, [:publishable_type, :publishable_id],
      :unique => true
  end
  
  def self.down
    drop_table :publications
  end
  
end
