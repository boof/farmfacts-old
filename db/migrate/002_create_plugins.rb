class CreatePlugins < ActiveRecord::Migration
  def self.up
    create_table :plugins do |t|
      t.string :name
      t.text :description
      
      t.string :feed
      t.string :homepage
      
      t.timestamps
    end
  end

  def self.down
    drop_table :plugins
  end
end
