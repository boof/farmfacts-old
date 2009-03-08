ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'pages', :action => 'show'

  map.admin_dashboard '/admin', :controller => 'admin/dashboard'
  map.with_options :controller => 'users', :path_prefix => '/admin' do |users|
    users.auth '/auth', :action => 'auth', :conditions => {:method => :post}
    users.logout '/logout', :action => 'logout'
  end
  map.namespace :admin do |admin|

    admin.page 'pages/theme',
        :name_prefix => 'theme_admin_',
        :conditions => {:method => :get},
        :controller => 'pages', :action => 'theme'
    admin.resources :pages, :except => [:destroy],
        :collection => { :bulk => :post }, :member => {:preview => :get} do |pages|
      pages.resources :attachments, :only => :create,
          :collection => { :bulk => :post }
    end
    admin.with_options :controller => 'themes' do |themes|
      themes.themes 'themes', :conditions => {:method => :get}
      themes.theme 'themes/:name', :conditions => {:method => :get},
          :action => 'show'
      themes.connect 'themes/:name', :conditions => {:method => :post},
          :action => 'install'
      themes.connect 'themes/:name', :conditions => {:method => :delete},
          :action => 'uninstall'
    end
    admin.pages 'themes/:theme_id/pages',
        :name_prefix => 'admin_themed_',
        :conditions => {:method => :get},
        :controller => 'themed_pages', :action => 'index'
    admin.page 'themes/:theme_id/pages/new',
        :name_prefix => 'new_admin_themed_',
        :conditions => {:method => :get},
        :controller => 'themed_pages', :action => 'new'
    admin.connect 'themes/:theme_id/pages',
        :name_prefix => 'admin_themed_',
        :conditions => {:method => :post},
        :controller => 'themed_pages', :action => 'create'
    admin.resources :themed_pages,
        :only => [:edit, :update, :show], :member => {:preview => :get} do |themed_pages|
      themed_pages.resources :elements, :member => {:move_up => :put, :move_down => :put}
      themed_pages.resources :attachments, :member => {:move_up => :put, :move_down => :put}, :only => :create, :collection => { :bulk => :post }
    end

    admin.resources :categories, :except => [:destroy],
        :collection => { :bulk => :post }

    admin.browse_navigation 'navigations/browse/*ids', :controller => 'navigations', :action => 'show'
    admin.resources :navigations

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
