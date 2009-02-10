class PagesController < ApplicationController
  ASSETS = %w[ css flv gif jpeg jpg js png swf exe cgi pl ]

  def show
    @page = Page.open request_path
    @page.render
  rescue ActiveRecord::RecordNotFound
    request_path != '/404' ? redirect_to('/404') : render_404
  end
  caches_page :show

  protected
  def request_path
    request.path != '/' ? request.path : '/home'
  end

  def no_assets
    ASSETS.include? File.extname(request_path)[ 1.. -1 ] and
    render :nothing => true, :status => '404 Not Found'
  end
  before_filter :no_assets

end
