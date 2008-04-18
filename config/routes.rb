ActionController::Routing::Routes.draw do |map|
  map.resources :plugins

  
  map.root :controller => 'home'
  map.resources :pages
  
end
