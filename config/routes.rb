ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'home'

  map.with_options :controller => 'projects' do |projects|
    projects.project '/project/:id', :action => 'show'
    projects.project_feed '/project/:id/feed', :action => 'feed'

    projects.projects '/projects'
  end

  map.with_options :controller => 'users' do |users|
    users.auth '/auth', :action => 'auth', :conditions => {:method => :post}
    users.logout '/logout', :action => 'logout'
  end

  map.with_options :controller => 'blog' do |blog|
    blog.articles '/blog'
    blog.map '/blog/:page', :page => /\d+/

    blog.article_by_ident '/blog/:id', :action => 'show'
    blog.find_article_by_date '/blog/:date', :action => 'find_by_date',
      :date => /(?:today|(?:\d{2}|\d{4})(?:-\d{1,2}(?:-\d{1,2})?)?)/
  end

  map.with_options :controller => 'comments' do |comments|
    comments.comment_news '/comment/news/:commented_id',
      :conditions => { :method => :post },
      :action => 'create', :commented_type => 'Article'
    comments.connect '/comment/news/:commented_id',
      :conditions => { :method => :get },
      :action => 'new', :commented_type => 'Article'
    comments.news_comments '/news/:id/comments/:offset',
      :action => 'list', :type => 'Article',
      :defaults => {:offset => 0}
    comments.comment_page '/comment/page/:commented_id',
      :conditions => { :method => :post },
      :action => 'create', :commented_type => 'Page'
    comments.connect '/comment/page/:commented_id',
      :conditions => { :method => :get },
      :action => 'new', :commented_type => 'Page'
    comments.page_comments '/page/:id/comments/:offset',
      :action => 'list', :type => 'Page',
      :defaults => {:offset => '0'}
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
  end

  map.page_by_name '*p',
    :controller => 'pages', :action => 'show'

end
