class ArticleSweeper < ActionController::Caching::Sweeper
  observe Article, Publication, Comment

  def expire_cache(obj)
    case obj
    when Article
      expire_index
      expire_by_ident obj.ident
    when Publication
      if obj.publishable_type.eql? 'Article'
        expire_index
        expire_by_ident obj.publishable.ident
      end
    when Comment
      expire_by_ident obj.commented.ident if obj.commented_type.eql? 'Article'
    end
  end
  
  def expire_by_ident(ident)
    expire_page :controller => '/news', :action => 'show', :ident => ident
  end
  
  def expire_index
    expire_page :controller => '/news', :action => 'index'
  end
  
  def after_destroy(article)
    # sweep comments dir
    if article.is_a? Article
      public_path = news_comments_path(article.id)
      path = File.join RAILS_ROOT, 'public', public_path.split('/')
      
      FileUtils.rm_rf File.dirname(path)
      logger.info "Expired page: #{ File.dirname public_path }"
    end
    
    expire_cache article
  end
  
  alias_method :after_create, :expire_cache
  alias_method :after_update, :expire_cache
  alias_method :after_publish, :expire_cache
  alias_method :after_revoke, :expire_cache
  
end
