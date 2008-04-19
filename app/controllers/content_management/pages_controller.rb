class ContentManagement::PagesController < ContentManagement::Base
  
  def index
    @pages = Page.find :all, :order => :name
  end
  
  def new
    @page = Page.new
  end
  
  def edit
    @page = Page.find params[:id]
  end
  
end
