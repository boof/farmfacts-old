class NewsController < ApplicationController

  caches_page :index, :find_by_date, :show
  helper CommentsHelper
  session :off

  def index
    title_page 'Ruby Sequel News'

    @articles ||= Article.find_all_public :limit => 10, :include => :author,
      :order => 'articles.created_at DESC', :offset => params[:page].to_i * 10

    render :action => :index
  end

  def summary
    @articles = Article.find_all_public :limit => 10, :include => :author,
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

  verify :xhr => true, :only => :commits
  def commits
    @feed = CachedFeed.open SEQUEL_FEED_URL
  end

end
