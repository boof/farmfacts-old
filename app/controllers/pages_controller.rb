class PagesController < ApplicationController

  def show
    @page = Page.open request.path
    title_page @page.title
    render :file => 'shared/page'
  end
  caches_page :show

  protected
  def no_assets
    ASSETS.include? File.extname(request.path) and
    render :nothing => true, :status => '404 Not Found'
  end
  before_filter :no_assets

end
