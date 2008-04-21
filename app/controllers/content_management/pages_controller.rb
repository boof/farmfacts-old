class ContentManagement::PagesController < ContentManagement::Base
  
  def index
    @pages = Page.find :all, :order => :name, :include => :publication
    @page_title = 'Content Management - Pages'
  end
  
  def show
    @page = Page.find params[:id]
    @page_title = "Content Management - Preview Page '#{ @page.title }'"
  end
  
  def new
    @page ||= Page.new
    @page_title = 'Content Management - New Page'
    
    render :action => :new
  end
  
  def edit
    @page ||= Page.find params[:id]
    @page_title = "Content Management - Edit Page '#{ @page.title }'"
    
    render :action => :edit
  end
  
  def create
    @page = Page.new params[:page]
    
    user.will :save, @page do |saved|
      if saved
        redirect_to :action => :edit, :id => @page.id
      else
        send :new
      end
    end
  end
  
  def update
    @page = Page.find params[:id]
    @page.attributes = params[:page]
    
    respond_to do |wants|
      user.will :save, @page do |saved|
        if saved
          wants.html  { redirect_to :action => :edit, :id => @page.id }
          wants.js    { render :nothing => true }
        else
          send :edit
        end
      end
    end
  end
  
  def publish
    user.publish 'Page', params[:id]
    redirect_to :action => :index
  end
  
  def revoke
    user.revoke 'Page', params[:id]
    redirect_to :action => :index
  end
  
  def destroy
    user.will :destroy, Page.find( params[:id] )
    redirect_to :action => :index
  end
  
end
