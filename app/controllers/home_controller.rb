class HomeController < ApplicationController

  def index
    @page = Page.open '/home'
    render :file => 'shared/page'
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_pages_path
  end
  caches_page :index

end
