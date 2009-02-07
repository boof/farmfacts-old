ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'pages', :action => 'show', :p => ['home']

  map.resources :categories, :only => [:index, :show]

#  map.ymd_articles '/blog/ymd/:year/:month/:day', :controller => 'blog',
#      :year   => /\d{4}/,
#      :month  => /\d{1,2}/,
#      :day    => /\d{1,2}/,
#      :defaults => { :day => nil, :month => nil }
#  map.resources :blog, :only => [:index, :show]
#
#  map.with_options :controller => 'comments' do |comments|
#    comments.new_article_comment '/blog/:article_id/comment',
#      :action => 'new', :conditions => { :method => :get }
#    comments.article_comment '/blog/:article_id/comment',
#      :action => 'create', :conditions => { :method => :post }
#  end
#
#  map.projects '/projects', :conditions => { :method => :get },
#      :controller => 'projects'

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
#    admin.resources :articles, :except => [:destroy],
#        :collection => { :bulk => :post } do |articles|
#
#      articles.resource :announcement, :only => [:new, :create]
#      articles.resources :attachments, :only => :create,
#          :collection => { :bulk => :post }
#      articles.resources :comments, :collection => { :bulk => :post }, :only => []
#    end
    admin.resources :users, :except => [:destroy, :show],
      :collection => { :bulk => :post }

    admin.resources :categories, :except => [:destroy],
        :collection => { :bulk => :post }
#    admin.resources :projects, :except => [:destroy],
#        :collection => { :bulk => :post } do |projects|
#      projects.resources :attachments, :only => :create,
#          :collection => { :bulk => :post }
#      projects.resources :roles, :except => [:index, :show, :destroy],
#          :collection => { :bulk => :post }
#    end

    admin.resources :navigations do |navigations|
      navigations.resources :nodes, :except => [:index, :show, :destroy],
          :collection => { :bulk => :post },
          :member => { :move_up => :put, :move_down => :put }
    end

#    admin.preview_textile 'preview/textile',
#      :controller => 'previews', :action => 'render_textile'

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
