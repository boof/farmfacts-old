ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'pages', :action => 'show'

  map.with_options :controller => 'users', :path_prefix => '/admin' do |users|
    users.auth '/auth', :action => 'auth', :conditions => {:method => :post}
    users.logout '/logout', :action => 'logout'
  end

  map.admin_dashboard '/admin', :controller => 'admin/dashboard'
  map.namespace :admin do |admin|

    admin.resources :pages, :except => [:destroy],
        :collection => { :bulk => :post }, :member => {:preview => :get} do |pages|
      pages.resources :attachments, :only => :create,
          :collection => { :bulk => :post }
    end
    admin.resources :templates, :only => [:index] do |templates|
      templates.resources :templated_pages, :except => [:destroy],
          :collection => { :bulk => :post }, :member => {:preview => :get} do |pages|
        pages.resources :attachments, :only => :create,
            :collection => { :bulk => :post }
      end
    end
    

#    admin.resources :navigations do |navigations|
#      navigations.resources :nodes, :except => [:index, :show, :destroy],
#          :collection => { :bulk => :post },
#          :member => { :move_up => :put, :move_down => :put }
#    end

    admin.resources :categories, :except => [:destroy],
        :collection => { :bulk => :post }

    admin.resources :users, :except => [:destroy, :show],
      :collection => { :bulk => :post }

    admin.configure '/configure/:module_name',
      :controller => 'preferences', :action => 'edit',
      :module_name => 'FarmFacts',
      :conditions => { :method => :get }
    admin.connect '/configure/:module_name',
      :controller => 'preferences', :action => 'update',
      :module_name => 'FarmFacts',
      :conditions => { :method => :post }

    admin.setup '/setup',
      :controller => 'setup', :action => 'new',
      :conditions => { :method => :get }
    admin.connect '/setup',
      :controller => 'setup', :action => 'create',
      :conditions => { :method => :post }
  end

  map.page_by_name '*p', :conditions => { :method => :get },
    :controller => 'pages', :action => 'show'

end
