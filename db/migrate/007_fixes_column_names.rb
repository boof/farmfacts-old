class FixesColumnNames < ActiveRecord::Migration
  
  def self.up
    rename_column :articles, :user_id, :author_id
    rename_column :publications, :user_id, :editor_id
  end
  
  def self.down
    rename_column :publications, :editor_id, :user_id
    rename_column :articles, :author_id, :user_id
  end
  
end
