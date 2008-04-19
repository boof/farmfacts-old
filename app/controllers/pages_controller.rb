class PagesController < ApplicationController
  
  caches_page :show
  
  def show
    @page = Page.find_by_name params[:id]
    @page_title = @page.title
  end
  
end
