class ProjectSweeper < ActionController::Caching::Sweeper
  observe Project

  # TODO: expire category cache when name or website changed

  def expire_index(project)
    expire_page projects_path
  end

  alias_method :after_save,     :expire_index

  alias_method :after_destroy,  :expire_index

  protected
  def website_changed?
    @original_url != @project.url or
    @project.url.blank? and @original_github != @project.github
  end

end
