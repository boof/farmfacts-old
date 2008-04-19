ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'home'
  
  map.plugins '/plugins', :controller => 'plugins'
  map.plugin_by_name '/plugins/:id',
    :controller => 'plugins', :action => 'show'
  
  map.page_by_name '/:name',
    :controller => 'pages', :action => 'show'
  
  map.namespace :content_management do |cms|
    cms.resources :pages
    cms.resources :plugins
  end

end
