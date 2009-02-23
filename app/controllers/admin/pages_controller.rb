class Admin::PagesController < Admin::Base

  cache_sweeper :page_sweeper, :only => [:create, :update, :bulk]

  def index
    current.title = 'Pages'
    @pages = Page.selects(:id, :path, :disposition, :updated_at).find :all, :order => :path, :include => :oli
  end

  def preview
    @page.render
  end

  def show
    current.title = "Show: #{ @page.path }"
  end

  def theme
    current.title = 'New Page: Theme'
    @themes = Theme.all :order => 'name'
  end

  def new
    current.title = 'New Page: Content'
    render :action => :new
  end

  def edit
    current.title = "Edit: #{ @page.path }"
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
  def assign_new_page
    @page = Page.new :path => params[:path]
  end
  before_filter :assign_new_page, :only => [:new, :build, :create, :theme]
  def assign_existing_page
    @page = Page.find params[:id]
  end
  before_filter :assign_existing_page,
    :only => [:preview, :show, :edit, :update]

end
