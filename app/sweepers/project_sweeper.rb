class ProjectSweeper < ActionController::Caching::Sweeper
  observe Project

  def expire_cache(plugin)
    expire_index
    expire_by_id plugin.id
  end
  
  def expire_index
    expire_page plugins_path
  end
  
  def expire_by_id(id)
    expire_page plugin_path(id)
  end
  
  alias_method :after_create, :expire_cache
  alias_method :after_update, :expire_cache
  alias_method :after_destroy, :expire_cache
  
end
