class PagesController < ApplicationController
  # asset extensions that wont be delivered
  ASSETS = %w[ css flv gif jpeg jpg js png swf exe cgi pl ].
      map! { |e| ".#{ e }" }

  def show
    negotiated_page = Page.negotiate request
    Page.named(negotiated_page.name).each do |page|
      html = page.to_s
      cache_page html, "#{ page.path }.html"
      cache_page html, "/index#{ ".#{ page.locale }" if page.locale }.html" if page.index?
    end
    render :file => "#{ Rails.public_path }#{ negotiated_page.path }.html"
  rescue ActiveRecord::RecordNotFound
    request.path != '/404' ? redirect_to('/404') : render_404
  end

  protected
  def no_assets
    ASSETS.include? File.extname(request.path) and
    render :nothing => true, :status => 404
  end
  before_filter :no_assets

end
