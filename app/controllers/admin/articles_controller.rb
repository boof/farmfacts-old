class Admin::ArticlesController < Admin::Base

  PAGE_TITLES = {
    :index    => 'Articles',
    :show     => 'Preview "%s"',
    :new      => 'New Article',
    :edit     => 'Edit "%s"',
    :announce => 'Announce "%s"'
  }

  before_filter :assign_new_article, :only => [:new, :create]
  before_filter :assign_article_by_id, :only => [:show, :edit, :update, :announce]

  cache_sweeper :article_sweeper, :only => [:create, :update, :bulk]

  def index
    title_page :index
    @articles = Article.with_order.all :include => :publication
  end

  def bulk
    Article.bulk_methods.include? params[:bulk_action] and
    current_user.will params[:bulk_action], Article,
      params[:article_ids], params

    redirect_to :action => :index
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
    save_or_send :new, :article, admin_article_path(@article)
  end

  def update
    save_or_send :edit, :article, admin_article_path(@article)
  end

  def announce
    subject, body = params[:subject], params[:body]

    if subject.blank? or body.blank? then title_page :announce, @article
    else
      recipients = "#{ params[:recipients] }".split ','
      recipients.each do |r|
        Announce.deliver_article current_user, r.strip, subject, body
      end

      redirect_to :action => :index
    end
  end

  protected
  def assign_new_article
    @article = current_user.articles.build
  end
  def assign_article_by_id
    @article = Article.find params[:id]
  end

end
