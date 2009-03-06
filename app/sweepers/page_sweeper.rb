class PageSweeper < ActionController::Caching::Sweeper
  observe Page

  def before_update(page)
    @page_path = page.path_changed?? page.path_was : page.path
  end
  def after_update(page)
    expire_index if page.index?
    expire_page "#{ @page_path }.html"
  end

  def after_create(page)
    expire_index if page.index?
  end

  def default_expire(page)
    expire_index if page.index?
    expire_page "#{ page.path }.html"
  end
  alias_method :after_destroy, :default_expire
  alias_method :when_accepted, :default_expire
  alias_method :when_rejected, :default_expire

  def expire_index
    expire_page '/index.html'
  end

end
