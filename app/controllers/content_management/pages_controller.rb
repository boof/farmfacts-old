class ContentManagement::PagesController < ContentManagement::Base
  
  def index
    @pages = Page.find :all, :order => :name
    @page_title = 'Content Management - Pages'
  end
  
  def new
    @page = Page.new
    @page_title = 'Content Management - New Page'
    
    render :action => :new
  end
  
  def edit
    @page = Page.find params[:id]
    @page_title = "Content Management - Edit Page '#{ @page.title }'"
    
    render :action => :edit
  end
  
  def create
    @page = Page.new params[:page]
    
    if @page.save
      redirect_to :action => :edit, :id => @page.id
    else
      send :new
    end
  end
  
  def update
    @page = Page.find params[:id]
    @page.attributes = params[:page]
    
    respond_to do |wants|
      if @page.save
        wants.html  { redirect_to :action => :edit, :id => @page.id }
        wants.js    { render :nothing => true }
      else
        send :edit
      end
    end
  end
  
  def destroy
    Page.destroy params[:id]
    redirect_to :action => :index
  end
  
end
