class Admin::PagesController < Admin::Base

  PAGE_TITLES = {
    :index    => 'Pages',
    :show     => 'Preview "%s"',
    :new      => 'New Page',
    :edit     => 'Edit "%s"',
    :publish  => 'Publish "%s"'
  }

  before_filter :assign_page, :except => [:index, :bulk]

  cache_sweeper :page_sweeper, :except => [:index, :show, :new, :edit]

  def index
    title_page :index
    @pages = Page.find :all, :order => :path, :include => :publication
  end

  def bulk
    Page.bulk_methods.include? params[:bulk_action] and
    current_user.will params[:bulk_action], Page, params[:page_ids]

    redirect_to :action => :index
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
    save_or_send :new, :page, admin_page_path(@page)
  end

  def update
    save_or_send :edit, :page, admin_page_path(@page)
  end

  protected
  def assign_page
    @page = ( Page.find params[:id] rescue Page.new )
  end

end
