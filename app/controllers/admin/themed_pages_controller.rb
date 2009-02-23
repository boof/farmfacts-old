class Admin::ThemedPagesController < Admin::Base

  def show
    current.title = 'Page Builder'
  end

  def new
    current.title = 'New Themed Page'
  end

  def create
    save_or_render(:new, :themed_page) { |page| redirect_to admin_themed_page_path(page) }
  end

  def edit
    current.title = "Edit: #{ @themed_page.name }"
  end

  protected
  def assign_page
    @themed_page = ThemedPage.find params[:id]
  end
  before_filter :assign_page, :only => [:show, :edit]
  def assign_theme
    @theme = Theme.find params[:theme_id]
  end
  before_filter :assign_theme, :only => [:new, :create]
  def assign_new_page
    metadata = Preferences[:FarmFacts].metadata.merge('author' => current.user.name)
    @themed_page = @theme.themed_pages.build :metadata => metadata
  end
  before_filter :assign_new_page, :only => [:new, :create]

end
