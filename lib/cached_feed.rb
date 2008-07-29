require 'rubygems'
require 'feed_tools'

class CachedFeed < FeedTools::Feed

  CACHE = MemCache.new '127.0.0.1:11211', :namespace => 'cached_feeds'

  def self.open(url)
    feed = CACHE.get url

    unless feed
      feed = Serializable::Feed.new super
      CACHE.set url, feed, feed.time_to_live
    end

    feed
  end

  module Serializable
    class Feed
      attr_reader :entries, :time_to_live

      def initialize(feed)
        @entries = feed.entries.map { |entry| Entry.new entry }
        @time_to_live = feed.time_to_live
      end

      class Entry
        attr_reader :title, :link, :time

        def initialize(entry)
          @title  = entry.title
          @link   = entry.link
          @time   = entry.time
        end

      end
    end
  end

end
