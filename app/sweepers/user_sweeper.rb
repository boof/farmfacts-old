class UserSweeper < ActionController::Caching::Sweeper
  observe User

  def expire_article_and_project_index(user)
  end

  alias_method :after_update,   :expire_article_and_project_index
  alias_method :after_destroy,  :expire_article_and_project_index

end
