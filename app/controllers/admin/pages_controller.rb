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
    title_page :new
    render :action => :new
  end

  def edit
    title_page :edit, @page
    render :action => :edit
  end

  def create
    save_or_render :new, :page do |page|
      return_or_redirect_to admin_page_path(page)
    end
  end

  def update
    save_or_render :edit, :page, admin_page_path(@page)
  end

  def bulk
    Page.bulk_methods.include? params[:bulk_action] and
    Page.send params[:bulk_action], params[:page_ids]

    return_or_redirect_to admin_pages_path
  end

  protected
  def assign_page
    @page = ( Page.find params[:id] rescue Page.new )
  end
  before_filter :assign_page, :except => [:index, :bulk]

end
