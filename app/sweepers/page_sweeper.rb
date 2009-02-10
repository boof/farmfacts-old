class PageSweeper < ActionController::Caching::Sweeper
  observe Page

  def before_update(page)
    @original_path = page.path_changed?? page.path_was : page.path
  end
  def after_save(page)
    expire_page '/index.html' if page.homepage?
    expire_page @original_path || page.path
  end

  def default_expire(page)
    expire_page '/index.html' if page.homepage?
    expire_page page.path
  end
  alias_method :after_destroy, :default_expire
  alias_method :when_accepted, :default_expire
  alias_method :when_rejected, :default_expire

end
