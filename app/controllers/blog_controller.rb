class BlogController < ApplicationController

  caches_page :index, :find_by_date, :show
  session :off

  def index
    title_page 'Blog'

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
    @article = Article.find_public params[:id]
    @page_title = @article.title
  end

end
