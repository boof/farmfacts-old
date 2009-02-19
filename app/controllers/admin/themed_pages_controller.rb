class Admin::ThemedPagesController < Admin::Base

  def new
    page.title = 'New Themed Page'
  end

  def create
    save_or_render(:new, :themed_page) #{ |page| redirect_to admin_themed_page_elements_path(page) }
  end

  protected
  def assign_theme
    @theme = Theme.find params[:theme_id]
  end
  before_filter :assign_theme, :only => [:new, :create]
  def assign_new_page
    @themed_page = @theme.themed_pages.build do |page|
      page.title = Preferences[:FarmFacts].name
      page.path = params[:path]
      page.metadata = Preferences[:FarmFacts].metadata.
          merge('author' => current_user.name)
    end
  end
  before_filter :assign_new_page, :only => [:new, :create]

end
