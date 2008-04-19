class CreatePlugins < ActiveRecord::Migration
  def self.up
    create_table :plugins do |t|
      t.string :name
      t.text :description_markdown
      t.text :description
      
      t.string :feed_path
      
      t.references :author
      
      t.timestamps
    end
  end

  def self.down
    drop_table :plugins
  end
end
