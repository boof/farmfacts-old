class Admin::ArticlesController < Admin::Base

  PAGE_TITLES = {
    :index    => 'Articles',
    :show     => 'Preview "%s"',
    :new      => 'New Article',
    :edit     => 'Edit "%s"',
    :publish  => 'Publish "%s"'
  }

  before_filter :assign_new_article,
    :only => [:new, :create]
  before_filter :assign_article_by_id,
    :only => [:show, :edit, :update, :publish, :revoke, :destroy]

  cache_sweeper :article_sweeper, :except => [:index, :show, :new, :edit]

  def index
    title_page :index
    @articles = Article.find :all, :order => 'created_at DESC', :include => :publication
  end

  def show
    title_page :show, @article
  end

  def new
    title_page :new
    render :action => :new
  end

  def edit
    title_page :edit, @article
    render :action => :edit
  end

  def create
    @article.attributes = params[:article]

    if current_user.will(:save, @article)
      redirect_to admin_article_path(@article)
    else
      send :new
    end
  end

  def update
    @article.attributes = params[:article]

    if current_user.will(:save, @article)
      redirect_to admin_article_path(@article)
    else
      send :edit
    end
  end

  def publish
    title_page :publish, @article
    current_user.publish 'Article', @article.id
  end

  def announce
    current_user.will :deliver_article, Announce,
      current_user, params[:recipients], params[:subject], params[:body]

    redirect_to admin_articles_path
  end

  def revoke
    current_user.will :destroy, @article.publication
    redirect_to admin_articles_path
  end

  def destroy
    current_user.will :destroy, @article
    redirect_to admin_articles_path
  end

  protected
  def assign_new_article
    @article = current_user.articles.build
  end
  def assign_article_by_id
    @article = Article.find params[:id]
  end

end
