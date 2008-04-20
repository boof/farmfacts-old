require 'feed_tools'

FeedTools.configurations[:feed_cache] = 'FeedTools::DatabaseFeedCache'

class FeedTools::DatabaseFeedCache
  
  # Prevent extra query, but HTML5 IS REALLY SLOW!
  def self.set_up_correctly?() true end
    
end
