class PageSweeper < ActionController::Caching::Sweeper
  observe Page, Publication

  def expire_cache_for(page)
    page = case page
    when Page; page
    when Publication
      page.publishable if page.publishable_type.eql? 'Page'
    end
    
    if page
      # expire_page :controller => '/pages', :action => 'index'
      expire_page :controller => '/pages', :action => 'show',
        :names => page.name
    
      if page.is_homepage?
        expire_page :controller => '/home', :action => 'index'
      end
    end
  end
  
  alias_method :after_create, :expire_cache_for
  alias_method :after_update, :expire_cache_for
  alias_method :after_destroy, :expire_cache_for
  alias_method :after_publish, :expire_cache_for
  alias_method :after_revoke, :expire_cache_for
  
end
