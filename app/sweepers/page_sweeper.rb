class PageSweeper < ActionController::Caching::Sweeper
  observe Page

  def before_update(page)
    @original_path  = page.path_changed?? page.path_was : page.path
    @link_changed   = page.title_changed? || page.path_changed?
  end
  def after_save(page)
    expire_page '/index.html' if page.homepage?
    expire_page @original_path if @original_path
    expire_categories_fragments page.category_ids if @link_changed
  end
  def when_rejected(page)
    expire_page '/index.html' if page.homepage?
    expire_page page.path
    expire_categories_fragments page.category_ids
  end
  def after_destroy(page)
    expire_page '/index.html' if page.homepage?
    expire_page page.path
    expire_categories_fragments page.category_ids
  end

  protected
  def expire_categories_fragments(ids)
    expire_fragment %r"categories/(?:#{ ids * '|' })"
  end

end
