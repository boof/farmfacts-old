class ArticleSweeper < ActionController::Caching::Sweeper
  observe Article, Publication, Comment

  def expire_cache(obj)
    case obj
    when Article
      expire_index
      expire_by_id obj.id
    when Publication
      if obj.publishable_type.eql? 'Article'
        expire_index
        expire_by_id obj.publishable_id
      end
    when Comment
      expire_by_ident obj.commented.ident if obj.commented_type.eql? 'Article'
    end
  end
  
  def expire_by_id(id)
    glob = File.join Rails.root, %W[ public news "#{ id }-*" ]
    if path = Dir[glob].first
      expire_page "/#{ path[/public(?:\\|\/)(.+)/, 1] }"
    end
  end
  
  def expire_index
    expire_page :controller => '/news', :action => :index
  end
  
  def after_destroy(article)
    expire_page news_comments_path(article.id) if article.is_a? Article
    expire_cache article
  end
  
  alias_method :after_create, :expire_cache
  alias_method :after_update, :expire_cache
  alias_method :after_publish, :expire_cache
  alias_method :after_revoke, :expire_cache
  
end
