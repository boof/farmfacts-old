class Plugin < ActiveRecord::Base

  FEED_PATH_SQL = 'SELECT feed_path FROM plugins WHERE id = %i'
  def self.feed_for(id)
    feed_path = connection.select_value FEED_PATH_SQL % id
    CachedFeed.open feed_path if feed_path
  end

  def feed
    CachedFeed.open feed_path
  end

  def to_s
    self[:name]
  end

  validates_uniqueness_of :name
  validates_presence_of :name, :description

end
