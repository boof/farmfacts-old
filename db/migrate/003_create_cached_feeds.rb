class CreateCachedFeeds < ActiveRecord::Migration
  
  def self.up
    create_table :cached_feeds do |t|
      t.string :url
      t.string :href
      t.string :title
      t.string :link
      t.text :feed_data
      t.string :feed_data_type
      t.text :http_headers
      t.timestamp :last_retrieved
    end
    
    add_index :cached_feeds, :href, :unique => true
  end
  
  def self.down
    drop_table :cached_feeds
  end
  
end
