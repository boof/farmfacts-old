class Plugin < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  
  FEED_PATH_SQL = 'SELECT feed_path FROM plugins WHERE id = %i'
  def self.feed_for(id)
    FeedTools::Feed.open connection.select_value(FEED_PATH_SQL % id)
  end
  
  def feed
    FeedTools::Feed.open feed_path
  end
  
  validates_uniqueness_of :name
  validates_presence_of :name, :description_markdown
  
  before_save :markdown_description
  
  protected
  def markdown_description
    self[:description] = markdown self[:description_markdown]
  end
  
end
