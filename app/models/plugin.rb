class Plugin < ActiveRecord::Base
  
  def feed
    FeedTools::Feed.open feed_path
  end
  
end
