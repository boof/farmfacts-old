class CreatePublications < ActiveRecord::Migration
  
  def self.up
    create_table :publications do |t|
      t.references :user, :null => false
      t.references :publishable, :polymorphic => true, :null => false
      
      # FIXME: this is seriously not needed, just delete the publication!
      t.boolean :revoked, :default => true
      
      t.timestamps
    end
    
    add_index :publications, [:publishable_id, :publishable_type],
      :unique => true
    
    user = User.find :first
    
    Page.find(:first, :conditions => ['name IN (?)', %w[home not_found]]).
    each do |page|
      user.publish 'Page', page.id
    end
  end
  
  def self.down
    drop_table :publications
  end
  
end
