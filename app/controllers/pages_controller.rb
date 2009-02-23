class PagesController < ApplicationController
  # asset extensions that wont be delivered
  ASSETS = %w[ css flv gif jpeg jpg js png swf exe cgi pl ].
      map! { |e| ".#{ e }" }

  def show
    @page = Page.open request_path, request.accept_language
    @page.render
    # modify page caching that it caches all available locales
  rescue ActiveRecord::RecordNotFound
    request_path != '/404' ? redirect_to('/404') : render_404
  end
  caches_page :show

  protected
  def request_path
    request.path != '/' ? request.path : frontpage_path
  end

  def no_assets
    ASSETS.include? File.extname(request_path) and
    render :nothing => true, :status => 404
  end
  before_filter :no_assets

end
