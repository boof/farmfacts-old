class Admin::ElementsController < Admin::Base

  def index
    page.title = 'Page Builder'
    @theme = @themed_page.theme
  end

  # Renders build interface for iframe/object.
  def new
    element = @themed_page.elements.load params[:element_name]
    render :text => element.to_s(:form, :themed_page => @themed_page)
  end

  protected
  def assign_themed_page
    @themed_page = ThemedPage.find params[:themed_page_id]
  end
  before_filter :assign_themed_page

end
