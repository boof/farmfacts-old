class Admin::ElementsController < Admin::Base

  def new
    render_form 'New Element'
  end
  def edit
    render_form 'Edit Element'
  end

  def create
    save_element_and_return_to_page
  end
  def update
    save_element_and_return_to_page
  end
  def destroy
    @element.destroy
    
    redirect_to admin_themed_page_path(@themed_page)
  end
  protected
  def save_element_and_return_to_page
    @element.data = params[:element].to_hash
    @element.save

    redirect_to admin_themed_page_path(@themed_page)
  end
  def render_form(title)
    current.title = title
    render :text => @element.to_s(:form, :themed_page => @themed_page), :layout => true
  end
  def assign_themed_page
    @themed_page = ThemedPage.find params[:themed_page_id]
  end
  before_filter :assign_themed_page
  def assign_element_by_id
    @element = @themed_page.elements.find params[:id]
  end
  before_filter :assign_element_by_id, :only => [:edit, :update, :destroy]
  def assign_element_by_name
    @element = @themed_page.elements.load params[:element_name]
  end
  before_filter :assign_element_by_name, :only => [:new, :create]

end
