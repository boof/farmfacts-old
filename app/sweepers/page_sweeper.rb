class PageSweeper < ActionController::Caching::Sweeper
  observe Page

  def before_update(page)
    @original_path = page.compiled_path_changed??
      page.compiled_path_was : page.compiled_path
  end
  def after_save(page)
    expire_page '/index.html' if page.index?
    expire_page @original_path || page.compiled_path
  end

  def default_expire(page)
    expire_page '/index.html' if page.index?
    expire_page page.compiled_path
  end
  alias_method :after_destroy, :default_expire
  alias_method :when_accepted, :default_expire
  alias_method :when_rejected, :default_expire

end
