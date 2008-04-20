class CreatePublications < ActiveRecord::Migration
  
  def self.up
    create_table :publications do |t|
      t.references :user
      t.references :publishable, :polymorphic => true
      
      t.boolean :revoked
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :publications
  end
  
end
