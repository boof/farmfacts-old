class NavigationSweeper < ActionController::Caching::Sweeper
  observe Navigation::Container

  def remember_element_id(navigation)
    @element_id = navigation.element_id_was
  end
  alias_method :before_update, :remember_element_id
  alias_method :before_destroy, :remember_element_id

  def expire_cache(navigation)
    Rails.cache.delete File.join('navigations', @element_id)
    expire_main_pages if @element_id == 'main'
    expire_pages_querying
    expire_article_bodies_querying
  end
  alias_method :after_update, :expire_cache
  alias_method :after_destroy, :expire_cache

  protected
  def expire_main_pages
    expire_fragment %r"blog.page=\d+"
    expire_page '/categories.html'
    expire_fragment 'categories/\d+'
    expire_page '/index.html'
    expire_page '/projects.html'
  end
  
  def expire_pages_querying
    pages = Page.find :all, :select => :path,
        :conditions => ['body LIKE ?', "%<<'n:#{ @element_id }'%"]

    while page = pages.shift; expire_page page.path end
  end
  def expire_article_bodies_querying
    articles = Article.find :all, :select => :id,
        :conditions => ['body LIKE ?', "%<<'n:#{ @element_id }'%"]

    expire_fragment %r"article/(?:#{ articles.map! { |a| a.id } * '|' })"
  end

end
