ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'home'

  map.with_options :controller => 'projects' do |projects|
    projects.projects '/projects'
    projects.project '/projects/:id', :action => 'show'
  end

  map.with_options :controller => 'users' do |users|
    users.auth '/auth', :action => 'auth', :conditions => {:method => :post}
    users.logout '/logout', :action => 'logout'
  end

  map.with_options :controller => 'blog' do |blog|
    blog.articles '/blog'
    blog.article '/blog/:id', :action => 'show'
    blog.articles_on '/blog/:year/:month/:day',
        :year   => /\d{4}/,
        :month  => /\d{1,2}/,
        :day    => /\d{1,2}/,
        :defaults => { :day => nil, :month => nil }
  end

  map.with_options :controller => 'comments' do |comments|
    comments.comment_news '/blog/:commented_id/comment',
      :action => 'create', :commented_type => 'Article',
      :conditions => { :method => :post }
    comments.connect '/blog/:commented_id/comment',
      :action => 'new', :commented_type => 'Article',
      :conditions => { :method => :get }
  end

  map.namespace :admin do |admin|
    admin.resources :pages,
      :collection => { :bulk => :post }
    admin.resources :articles, :has_many => :comments,
      :collection => { :bulk => :post }, :member => { :announce => :any }
    admin.resources :users,
      :collection => { :bulk => :post }

    admin.resources :projects, :has_many => :roles

    admin.edit_navigations 'navigations',
      :controller => 'navigations', :action => 'edit',
      :conditions => { :method => :get }
    admin.update_navigations 'navigations',
      :controller => 'navigations', :action => 'update',
      :conditions => { :method => :put }

    admin.preview_markdown 'preview/markdown',
      :controller => 'previews', :action => 'render_markdown'

    admin.setup '/setup',
      :controller => 'setup', :action => 'new',
      :conditions => { :method => :get }
    admin.connect '/setup',
      :controller => 'setup', :action => 'create',
      :conditions => { :method => :post }
  end

  map.page_by_name '*p',
    :controller => 'pages', :action => 'show'

end
