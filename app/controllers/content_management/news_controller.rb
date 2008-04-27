class ContentManagement::NewsController < ContentManagement::Base
  
  before_filter :assign_article_by_id,
    :except => [:index, :preview, :new, :create, :announce, :revoke]
  cache_sweeper :article_sweeper,
    :except => [:index, :show, :new, :edit]
  
  def index
    @articles ||= Article.find :all,
      :order => 'articles.created_at DESC',
      :limit => 32, 
      :include => :publication
    @page_title = 'Content Management - News Articles'
    
    render :action => :index
  end
  
  def show
    @page_title = "Content Management - Preview Article '#{ @article.title }'"
  end
  
  def preview
    render :text => Maruku.new(params[:article][:content_markdown]).to_html
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
    @article = Article.new params[:article].merge(:user_id => user.id)
    
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
    
    user.will :save, @article do |saved|
      if saved
        redirect_to :action => :index
      else
        send :edit
      end
    end
  end
  
  def publish
    user.publish 'Article', params[:id]
  end
  
  def announce
    user.will :deliver_article, Announce,
      user, params[:recipients], params[:subject], params[:body]
    
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
