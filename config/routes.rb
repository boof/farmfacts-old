ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'pages', :action => 'show', :p => ['home']

  map.resources :categories, :only => [:index, :show]

  map.with_options :controller => 'users', :path_prefix => '/admin' do |users|
    users.auth '/auth', :action => 'auth', :conditions => {:method => :post}
    users.logout '/logout', :action => 'logout'
  end

  map.namespace :admin do |admin|
    admin.resources :pages, :except => [:destroy],
        :collection => { :bulk => :post } do |pages|
      pages.resources :attachments, :only => :create,
          :collection => { :bulk => :post }
    end

    admin.resources :users, :except => [:destroy, :show],
      :collection => { :bulk => :post }

    admin.resources :categories, :except => [:destroy],
        :collection => { :bulk => :post }

    admin.resources :navigations do |navigations|
      navigations.resources :nodes, :except => [:index, :show, :destroy],
          :collection => { :bulk => :post },
          :member => { :move_up => :put, :move_down => :put }
    end

    admin.setup '/setup',
      :controller => 'setup', :action => 'new',
      :conditions => { :method => :get }
    admin.connect '/setup',
      :controller => 'setup', :action => 'create',
      :conditions => { :method => :post }

#    admin.preview_textile 'preview/textile',
#      :controller => 'previews', :action => 'render_textile'
  end

  map.page_by_name '*p', :conditions => { :method => :get },
    :controller => 'pages', :action => 'show'

end
