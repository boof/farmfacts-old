class PagesController < ApplicationController
  
  caches_page :show
  helper CommentsHelper
  
  def show
    @page = Page.find_by_name params[:names].join('/')
    @page_title = @page.title
    
    not_found(@page) if @page.not_found?
  end
  
end
