class NewsController < ApplicationController
  
  caches_page :index, :find_by_date, :show
  
  def index
    @articles ||= Article.find_all_public :order => 'articles.created_at DESC', :limit => 10
    @page_title = 'Ruby Sequel News'
    
    render :action => :index
  end
  
  def find_by_date
    date = if params[:date].eql? 'today' then Date.today
    else
    end
    
    # stub
    @articles = Article.find :all
    send :index
  end
  
  def show
    @article = Article.find_by_ident params[:ident]
    render :template => 'pages/show' if @article.is_not_found?
  end
  
  FEED_PATH = 'http://github.com/feeds/jeremyevans/commits/sequel/master'
  def commits
    respond_to do |wants|
      wants.html  { render :nothing => true, :status => 404 }
      wants.js    { @feed = FeedTools::Feed.open FEED_PATH }
    end
  end
  
end
