class Plugin < ActiveRecord::Base
  
  has_many :commits do
    def refresh
      REXML::Document.
        parse_stream proxy_owner.feed_uri, FeedParser.new(proxy_owner)
    end
  end
  
  class FeedParser
    
    def initialize(plugin)
      @plugin = plugin
      @path   = []
    end
    
    def start_tag(tag, attrs)
      @path << tag
      
      case tag
      when 'updated'
      when 'entry'
        @commit_params = {}
      end
    end
    
    def ent_tag(tag)
      case tag
      when 'updated'
      when 'entry'
        if @commit[:updated] < @plugin.updated_at
          false
        else
          commit = @plugin.commits.build @commit_params
          commit.save
        end
      end
      
      element = @path.pop
    end
    
    def text(content)
    end
    
    def instruction(xml, attrs)
    end
    
    def doctype(tag, *opts)
    end
    
    [
      :comment,
      :attlistdecl,
      :notationdecl,
      :elementdecl,
      :entitydecl,
      :cdata,
      :xmldecl,
      :attlistdecl
    ].
    each { |stub| define_method(stub) {|*args|} }
    
  end
  
end
