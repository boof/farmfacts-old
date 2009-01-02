class Admin::PagesController < Admin::Base

  cache_sweeper :categorization_sweeper, :only => [:create, :update, :bulk]
  cache_sweeper :page_sweeper, :only => [:create, :update, :bulk]

  PAGE_TITLES = {
    :index    => 'Pages',
    :show     => 'Page “%s”',
    :new      => 'New Page',
    :edit     => 'Edit Page “%s”'
  }

  def index
    title_page :index
    @pages = Page.rejects(:body, :summary).find :all, :order => :path, :include => :oli
  end

  def show
    title_page :show, @page
  end

  def new
    # repair broken default text values in sqlite
    if Page.connection.respond_to? :sqlite_version
      default_body = Page.columns_hash['body'].default
      @page['body'] = default_body.slice 1, default_body.length - 2
    end

    title_page :new
    render :action => :new
  end

  def edit
    title_page :edit, @page
    render :action => :edit
  end

  def create
    save_or_send :new, :page do |page|
      redirect_to admin_page_path(page)
    end
  end

  def update
    save_or_send :edit, :page do |page|
      redirect_to admin_page_path(page)
    end
  end

  def bulk
    Page.bulk_methods.include? params[:bulk_action] and
    current_user.will params[:bulk_action], Page, params[:page_ids]

    redirect_to :action => :index
  end

  protected
  def assign_page
    @page = ( Page.find params[:id] rescue Page.new )
  end
  before_filter :assign_page, :except => [:index, :bulk]

end
