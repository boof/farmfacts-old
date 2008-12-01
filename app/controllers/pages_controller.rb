class PagesController < ApplicationController

  caches_page :show
  session :off

  def show
    @page = Page.open request.path
    title_page @page.title
  end

  protected
  def no_assets
    ASSETS.include? request.path[-3, 3] and
    render :nothing => true, :status => '404 Not Found'
  end
  before_filter :no_assets

end
