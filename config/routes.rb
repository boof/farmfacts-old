ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'home'
  
  map.page_by_name '/pages/:name', :controller => 'pages', :action => :show
  map.resources :pages
  
  map.resources :plugins
  
end
