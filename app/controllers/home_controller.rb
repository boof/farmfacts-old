class HomeController < ApplicationController

  session :off
  caches_page :index

  def index
    @homepage   = Page.open '/home'
    @page_title = @homepage.title
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_pages_path
  end

end
