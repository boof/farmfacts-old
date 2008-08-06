ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'home'

  map.with_options :controller => 'plugins' do |plugins|
    plugins.plugin '/plugin/:id', :action => 'show'
    plugins.plugin_feed '/plugin/:id/feed', :action => 'feed'

    plugins.plugins '/plugins'
  end

  map.with_options :controller => 'users' do |users|
    users.login '/login', :action => 'login'
    users.auth '/auth', :action => 'auth', :conditions => {:method => :post}
    users.logout '/logout', :action => 'logout'
  end

  map.with_options :controller => 'news' do |news|
    news.commits '/commits', :action => 'commits'

    news.summary '/news/summary', :action => 'summary'

    news.find_news_by_date '/news/:date', :action => 'find_by_date',
      :date => /(?:today|(?:\d{2}|\d{4})(?:-\d{1,2}(?:-\d{1,2})?)?)/
    news.find_news_by_ident '/news/:ident', :action => 'show',
      :ident => /\d+-.+/

    news.news '/news/:page', :defaults => {:page => '0'}
  end

  map.with_options :controller => 'comments' do |comments|
    comments.comment_news '/comment/news/:commented_id',
      :conditions => { :method => :post },
      :action => 'create', :commented_type => 'Article'
    comments.connect '/comment/news/:commented_id',
      :conditions => { :method => :get },
      :action => 'new', :commented_type => 'Article'
    comments.news_comments '/news/:id/comments/:offset',
      :action => 'list', :type => 'Article',
      :defaults => {:offset => 0}
    comments.comment_page '/comment/page/:commented_id',
      :conditions => { :method => :post },
      :action => 'create', :commented_type => 'Page'
    comments.connect '/comment/page/:commented_id',
      :conditions => { :method => :get },
      :action => 'new', :commented_type => 'Page'
    comments.page_comments '/page/:id/comments/:offset',
      :action => 'list', :type => 'Page',
      :defaults => {:offset => '0'}
  end

  map.namespace :admin do |admin|
    admin.resources :pages,
      :collection => {:preview => :post},
      :member => {:publish => :post, :revoke => :post}
    admin.resources :articles,
      :collection => {:preview => :post},
      :member => {:publish => :post, :announce => :post, :revoke => :post}
    admin.resources :plugins
    admin.resources :users

    admin.preview_markdown 'preview/markdown',
      :controller => 'previews', :action => 'render_markdown'
  end

  map.page_by_name '*p',
    :controller => 'pages', :action => 'show'

end
