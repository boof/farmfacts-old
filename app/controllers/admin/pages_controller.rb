class Admin::PagesController < Admin::Base

  cache_sweeper :page_sweeper, :only => [:create, :update, :bulk]

  def index
    page.title = 'Pages'
    @pages = Page.selects(:id, :title, :compiled_path, :updated_at).find :all, :order => :path, :include => :oli
  end

  def preview
    @page.render
  end

  def show
    page.title = "Show: #{ @page.title }"
  end

  def new
    page.title = 'New Page - Select Template'
  end

  def build
    if params[:page][:template_id].blank?
      page.title = 'New Page - Write Content'
      render :action => :build
    else
      redirect_to new_admin_template_templated_page_path(params[:page][:template_id])
    end
  end

  def edit
    page.title = "Edit: #{ @page.title }"
    render :action => :edit
  end

  def create
    save_or_render :build, :page do |page|
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
    @page = Page.new do |page|
      page.title = Preferences[:FarmFacts].name
      page.path = params[:path]
      page.metadata = Preferences[:FarmFacts].metadata.
          merge('author' => current_user.name)
    end
  end
  before_filter :assign_new_page, :only => [:new, :build, :create]
  def assign_existing_page
    @page = Page.find params[:id]
  end
  before_filter :assign_existing_page,
    :only => [:preview, :show, :edit, :update]

end
