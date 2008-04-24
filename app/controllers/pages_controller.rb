class PagesController < ApplicationController
  
  caches_page :show
  
  def show
    @page = Page.find_by_name params[:names].join('/')
    @page_title = @page.title
    
    render :status => 404 if @page.name.eql? 'not_found'
  end
  
end
