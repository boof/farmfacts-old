class CreatePlugins < ActiveRecord::Migration
  
  def self.up
    create_table :plugins do |t|
      t.string :name, :null => false
      
      t.string :contributor_name
      t.string :contributor_email
      
      t.text :description_markdown, :null => false
      t.text :description
      
      t.string :feed_path
      t.string :documentation_path
    end
    
    plugin = Plugin.new do |plugin|
      plugin.name = 'NotNaughty'
      
      plugin.contributor_name = 'Florian Aßmann'
      plugin.contributor_email = 'florian.assmann@email.de'
      
      plugin.description_markdown = 'Adapter for the Validation Framework NotNaughty.'
      
      plugin.feed_path = 'http://github.com/feeds/boof/commits/notnaughty/master'
      plugin.documentation_path = 'http://not-naughty.rubyforge.org/'
    end
    
    plugin.save || raise('Could not create plugin!')
  end
  
  def self.down
    drop_table :plugins
  end
  
end
