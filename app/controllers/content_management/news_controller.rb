class ContentManagement::NewsController < ContentManagement::Base
  
  before_filter :assign_article_by_id,
    :only => [:edit, :update, :destroy, :announce]
  cache_sweeper :article_sweeper,
    :except => [:index, :show, :new, :edit]
  
  def index
    @articles ||= Article.find :all, :order => 'created_at DESC', :limit => 32
    @page_title = 'Content Management - News Articles'
    
    render :action => :index
  end
  
  def show
    @page_title = "Content Management - Preview Article '#{ @article.title }'"
  end
  
  def new
    @article ||= Article.new
    @page_title = 'Content Management - New Article'
    
    render :action => :new
  end
  
  def edit
    @page_title = "Content Management - Edit Article '#{ @article.title }'"
    
    render :action => :edit
  end
  
  def create
    @article = Article.new params[:article].merge(:author => user)
    
    user.will :save, @article do |saved|
      if saved
        redirect_to :action => :index
      else
        send :new
      end
    end
  end
  
  def update
    @article.attributes = params[:article]
    
    respond_to do |wants|
      user.will :save, @article do |saved|
        if saved
          wants.html  { redirect_to :action => :edit, :id => @article.id }
          wants.js    {}
        else
          wants.html  { send :edit }
          wants.js    { flash.now[:message] = 'Page failed to save' }
        end
      end
    end
  end
  
  def publish
    user.publish 'Article', params[:id]
  end
  
  def announce
    user.will :announce, @article, user, params[:recipients], params[:prefix]
    redirect_to :action => :index
  end
  
  def revoke
    user.revoke 'Article', params[:id]
    redirect_to :action => :index
  end
  
  def destroy
    user.will :destroy, @article
    redirect_to :action => :index
  end
  
  protected
  def assign_article_by_id
    @article = Article.find params[:id]
  end
  
end
