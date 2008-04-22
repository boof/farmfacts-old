ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'home'
  
  map.with_options :controller => 'plugins' do |plugins|
    plugins.plugins '/plugins'
    plugins.plugin '/plugin/:id', :action => 'show'
    plugins.plugin_feed '/plugin/:id/feed', :action => 'feed'
  end
  
  map.with_options :controller => 'users' do |users|
    users.login '/login', :action => 'login'
    users.auth '/auth', :action => 'auth', :conditions => {:method => :post}
    users.logout '/logout', :action => 'logout'
  end
  
  map.with_options :controller => 'news' do |news|
    news.news '/news'
    
    news.find_news_by_date '/news/:date', :action => 'find_by_date',
      :date => /(?:today|(?:\d{2}|\d{4})(?:-\d{1,2}(?:-\d{1,2})?)?)/
    
    news.find_news_by_ident '/news/:ident', :action => 'show',
      :ident => /\d+-.+/
  end
  
  map.page_by_name '/:name',
    :controller => 'pages', :action => 'show'
  
  map.namespace :content_management do |cms|
    cms.resources :pages,
      :member => {:publish => :post, :revoke => :post}
    cms.resources :news,
      :member => {:publish => :post, :revoke => :post}
    cms.resources :plugins
    cms.resources :users
  end

end
