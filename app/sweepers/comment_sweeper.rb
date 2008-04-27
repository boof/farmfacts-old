class CommentSweeper < ActionController::Caching::Sweeper
  observe Comment

  def expire_cache_for(comment)
    expire_page :controller => '/comments', :action => 'list',
      :type => comment.commented_type,
      :id => comment.commented_id
  end
  
  alias_method :after_create, :expire_cache_for
  alias_method :after_update, :expire_cache_for
  
end
