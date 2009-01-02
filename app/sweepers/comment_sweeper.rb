class CommentSweeper < ActionController::Caching::Sweeper
  observe Comment

  def expire_cache(comment)
    @comment = comment
    expire_article_fragments if article_comment?
  end

  protected
  def article_comment?
    @comment.commented_type == 'Article'
  end
  def expire_article_fragments
    expire_fragment %r'article/comments/#{ @comment.commented_id }'
    expire_fragment %r"blog.page=#{ html_page }"
    expire_fragment %r'blog/#{ @comment.commented_id }.atom'
  end
  def html_page
    Article.accepted.ordered('onlists.created_at DESC').
        offset(@comment.commented_id) / 10 + 1
  end

end
