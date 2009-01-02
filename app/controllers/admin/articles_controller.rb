class Admin::ArticlesController < Admin::Base

  SWEEPER_ACTIONS = [:create, :update, :bulk]
  cache_sweeper :categorization_sweeper, :only => SWEEPER_ACTIONS
  cache_sweeper :article_sweeper, :only => SWEEPER_ACTIONS
  cache_sweeper :navigation_sweeper, :only => SWEEPER_ACTIONS

  PAGE_TITLES = {
    :index    => 'Articles',
    :show     => 'Article “%s”',
    :new      => 'New Article',
    :edit     => 'Edit Article “%s”',
    :announce => 'Announce “%s”'
  }

  def index
    title_page :index
    @articles = Article.
        ordered('onlists.created_at DESC', 'articles.created_at DESC').
        find :all, :include => :oli
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
    save_or_send :new, :article do |article|
      redirect_to admin_article_path(article.id)
    end
  end

  def update
    save_or_send :edit, :article, admin_article_path(@article.id)
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
    @article = current_user.articles.build :author_id => current_user.id
  end
  before_filter :assign_new_article, :only => [:new, :create]

  def assign_article_by_id
    @article = Article.find params[:id]
  end
  before_filter :assign_article_by_id, :only => [:show, :edit, :update, :announce]

end
