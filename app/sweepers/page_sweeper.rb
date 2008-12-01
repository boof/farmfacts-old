class PageSweeper < ActionController::Caching::Sweeper
  observe Page, Comment

  def expire_cache(obj)
    case obj
    when Page
      expire_index
      expire_by_name obj.old_name
    when Publication
      if obj.publishable_type.eql? 'Page'
        expire_index
        expire_by_name obj.publishable.name
      end
    when Comment
      expire_by_name obj.commented.name if obj.commented_type.eql? 'Page'
    end
  end

  def expire_index
    # expire_page :controller => '/pages', :action => 'index'
  end

  def expire_by_name(name)
    expire_page :controller => '/pages', :action => 'show', :names => name
  end

  def expire_homepage
    expire_page :controller => '/home', :action => 'index'
  end

  def after_destroy(page)
    if page.is_a? Page
      expire_page page_comments_path(page.id)
      expire_homepage if page.homepage?
    end
    expire_cache page
  end

  def after_update(page)
    expire_homepage if page.is_a? Page and page.homepage?
    expire_cache page
  end

  def before_save(page)
    page.old_name = Page.name_by_id(page.id) if page.is_a? Page
  end

  alias_method :after_create, :expire_cache
  alias_method :after_publish, :expire_cache
  alias_method :after_revoke, :expire_cache

end
