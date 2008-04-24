class ArticleSweeper < ActionController::Caching::Sweeper
  observe Article, Publication

  def expire_cache(article)
    article = case article
    when Article; article
    when Publication
      article.publishable if article.publishable_type.eql? 'Article'
    end
    
    if article
      expire_page :controller => '/news', :action => 'index'
      expire_page :controller => '/news', :action => 'show',
        :ident => article.ident
    end
  end
  
  alias_method :after_create, :expire_cache
  alias_method :after_update, :expire_cache
  alias_method :after_destroy, :expire_cache
  alias_method :after_publish, :expire_cache
  alias_method :after_revoke, :expire_cache
  
end
