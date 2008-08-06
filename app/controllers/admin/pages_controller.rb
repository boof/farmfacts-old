class Admin::PagesController < Admin::Base

  PAGE_TITLES = {
    :index    => 'Pages',
    :show     => 'Preview "%s"',
    :new      => 'New Page',
    :edit     => 'Edit "%s"',
    :publish  => 'Publish "%s"'
  }

  before_filter :assign_new_page,
    :only => [:new, :create]
  before_filter :assign_page_by_id,
    :only => [:show, :edit, :update, :revoke, :destroy]

  cache_sweeper :page_sweeper, :except => [:index, :show, :new, :edit]

  def index
    title_page :index
    @pages = Page.find :all, :order => :name, :include => :publication
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
    @page.attributes = params[:page]

    if current_user.will(:save, @page)
      redirect_to admin_page_path(@page)
    else
      send :new
    end
  end

  def update
    @page.attributes = params[:page]

    if current_user.will(:save, @page)
      redirect_to admin_page_path(@page)
    else
      send :edit
    end
  end

  def publish
    current_user.publish 'Page', params[:id]
    redirect_to admin_pages_path
  end

  def revoke
    current_user.will :destroy, @page.publication
    redirect_to admin_pages_path
  end

  def destroy
    current_user.will :destroy, @page
    redirect_to admin_pages_path
  end

  protected
  def assign_new_page
    @page = Page.new
  end
  def assign_page_by_id
    @page = Page.find params[:id]
  end

end
