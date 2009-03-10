class Admin::ThemedPagesController < Admin::Base

  def index
    current.title = t :themed_pages
  end

  def show
    current.title = t :page_builder
  end

  def new
    current.title = "#{ t :new } #{ t :themed_page }"
  end
  def create
    save_or_render(:new, :themed_page) { |page| redirect_to admin_themed_page_path(page) }
  end

  def edit
    current.title = "#{t :edit} #{t :themed_page} #{@themed_page.name}"
  end
  def update
    save_or_render :edit, :themed_page, admin_themed_page_path(@themed_page)
  end

  protected
  def assign_theme
    @theme = Theme.find params[:theme_id]
  end
  before_filter :assign_theme, :only => [:index, :new, :create]
  def assign_page
    @themed_page = ThemedPage.find params[:id]
  end
  before_filter :assign_page, :only => [:show, :edit, :update]
  def assign_new_page
    metadata = Preferences[:FarmFacts].metadata.merge('author' => current.user.name)
    @themed_page = @theme.themed_pages.build :metadata => metadata
  end
  before_filter :assign_new_page, :only => [:new, :create]

end
