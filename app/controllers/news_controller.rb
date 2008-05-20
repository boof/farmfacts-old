class NewsController < ApplicationController
  
  caches_page :index, :find_by_date, :show
  helper CommentsHelper
  
  def index
    @page_title = 'Ruby Sequel News'
    
    @articles ||= Article.find_all_public :limit => 10, :include => :author,
      :order => 'articles.created_at DESC', :offset => params[:page].to_i * 10
    
    render :action => :index
  end
  
  def summary
    @articles = Article.find_all_public :limit => 4, :include => :author,
      :order => 'articles.created_at DESC'
  end
  
  def find_by_date
    date = if params[:date].eql? 'today' then Date.today
    else
    end
    
    # stub
    @articles = Article.find :all, :include => :author
    send :index
  end
  
  def show
    @article = Article.find_by_ident params[:ident]
    @page_title = @article.title
    
    not_found(@article) if @article.not_found?
  end
  
  def commits
    respond_to do |wants|
      wants.html  { render :nothing => true, :status => 400 }
      wants.js    { @feed = MemcachedFeed.open FEED_PATH }
    end
  end
  
end
