require 'rubygems'
require 'memcached'
require 'feed_tools'

class MemcachedFeed < FeedTools::Feed
  
  # TODO: write configuration mechanizm
  CACHE = Memcached.new '127.0.0.1:11211'
  
  def self.open(url)
    begin
      CACHE.get url
      
    rescue Memcached::NotFound
      feed = Serializable::Feed.new super
      CACHE.set url, feed, feed.time_to_live
      
      feed
    end
  end
  
  module Serializable
    class Feed
      attr_reader :entries, :time_to_live
      
      def initialize(feed)
        @entries = feed.entries.map { |entry| Entry.new entry }
        @time_to_live = feed.time_to_live
      end
      
      class Entry
        attr_reader :title, :link, :summary, :time

        def initialize(entry)
          @title    = entry.title
          @link     = entry.link
          @summary  = entry.summary
          @time     = entry.time
        end
      end
    end
  end
end
