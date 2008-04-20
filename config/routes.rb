ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'home'
  
  map.plugins '/plugins', :controller => 'plugins'
  map.plugin '/plugin/:id',
    :controller => 'plugins', :action => 'show'
  map.plugin_feed '/plugin/:id/feed',
    :controller => 'plugins', :action => 'feed'
  
  map.page_by_name '/:name',
    :controller => 'pages', :action => 'show'
  
  map.namespace :content_management do |cms|
    cms.resources :pages
    cms.resources :plugins
  end

end
