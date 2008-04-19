class HomeController < ApplicationController
  
  caches_page :index
  
  def index
    @homepage = Page.find_by_name 'home'
    @page_title = @homepage.title
  end
  
end
