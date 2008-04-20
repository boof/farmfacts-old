ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'home'
  
  map.plugins '/plugins', :controller => 'plugins'
  map.plugin '/plugin/:id',
    :controller => 'plugins', :action => 'show'
  map.plugin_feed '/plugin/:id/feed',
    :controller => 'plugins', :action => 'feed'
  
  map.login '/login',
    :controller => 'users', :action => 'login'
  map.authentication '/authenticate', :conditions => {:method => :post},
    :controller => 'users', :action => 'authenticate'
  map.logout '/logout',
    :controller => 'users', :action => 'logout'
  
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
