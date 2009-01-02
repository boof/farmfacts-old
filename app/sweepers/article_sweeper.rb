class ArticleSweeper < ActionController::Caching::Sweeper
  observe Article

  # TODO: expire paginated with date filter

  def before_save(article)
    @title_changed  = !!article.title_changed?
    @teaser_changed = !!article.teaser_changed?
    @body_changed   = !!article.body_changed?
    @article_id     = article.id
    @offset = Article.accepted.ordered('onlists.created_at DESC').
        offset(@article_id)
  end
  def before_destroy(article)
    @article_id = article.id
    @offset = Article.accepted.ordered('onlists.created_at DESC').
        offset(@article_id)
  end

  def when_accepted(article)
    @offset = Article.accepted.ordered('onlists.created_at DESC').
        offset(@article_id)
    expire_categories_fragments article
    flush_index_pages
  end
  def when_rejected(article)
    @offset = Article.accepted.ordered('onlists.created_at DESC').
        offset(@article_id)
    expire_categories_fragments article
    flush_index_pages
  end

  def after_save(article)
    if @title_changed
      expire_categories_fragments article
      expire_article_feed
    end
    expire_body_fragment if @body_changed
    expire_index
  end

  def after_destroy(article)
    expire_categories_fragments article.category_ids
    expire_article_fragments
    flush_index_pages
    expire_article_feed
  end

  protected
  def expire_categories_fragments(article)
    expire_fragment %r"categories/(?:#{ article.category_ids * '|' })"
  end
  def expire_index(page = index_page)
    expire_fragment %r"blog.page=#{ page }"
    expire_page '/blog.atom' if blog_fed?
  end
  def flush_index_pages
    expire_index "(?:#{ Array.new(index_page) { |i| i + 1 } * '|' })"
  end
  def expire_body_fragment
    expire_fragment %r"article/#{ @article_id }"
  end
  def expire_article_fragments
    expire_body_fragment
    expire_fragment %r"article/.+/#{ @article_id }"
  end
  def expire_article_feed
    expire_fragment %r"blog/#{ @article_id }.atom"
  end
  def blog_fed?
    @offset / 15 + 1 < 2
  end
  def index_page
    @offset / 10 + 1
  end

end
