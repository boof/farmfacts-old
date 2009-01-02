class CategorizationSweeper < ActionController::Caching::Sweeper
  observe Categorization = Categorizable::Categorization

  def expire_cache(categorization)
    expire_page '/categories.html'
    expire_fragment category_path(categorization.category_id)
    expire_article_fragments article_ids(categorization.category_id) <<
        categorization.categorizable_id
  end

  alias_method :after_save,     :expire_cache
  alias_method :after_destroy,  :expire_cache

  protected
  def category_path(id)
    %r"categories/#{ id }"
  end
  def polymorphic_ids(category_id, type)
    conditions = {:category_id => category_id, :categorizable_type => type}
    opts = {:conditions => conditions, :select => :categorizable_id}

    Categorization.find(:all, opts).map! { |c| c.categorizable_id }
  end
  def article_ids(category_id)
    polymorphic_ids category_id, 'Article'
  end
  def expire_article_fragments(ids)
    expire_fragment %r"article/clouds/(?:#{ ids * '|' })"
    expire_fragment %r"article/relatives/(?:#{ ids * '|' })"
  end

end
