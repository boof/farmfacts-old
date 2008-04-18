class PagesController < ApplicationController
  
  caches_page :show, :new
  
  def show
    @page = Page.find_by_name params[:id]
  end
  
end
