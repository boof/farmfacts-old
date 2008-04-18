class CreateCommits < ActiveRecord::Migration
  def self.up
    create_table :commits do |t|
      t.string :feed
      
      t.string :link
      t.string :author
      t.string :title
      t.text :content
      
      t.references :plugin
      
      t.timestamps
    end
  end

  def self.down
    drop_table :commits
  end
end
