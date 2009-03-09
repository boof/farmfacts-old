class PagesController < ApplicationController
  # asset extensions that wont be delivered
  ASSETS = %w[ css flv gif jpeg jpg js png swf exe cgi pl ].
      map! { |e| ".#{ e }" }

  def show
    negotiated_page = Page.negotiate request
    Page.named(negotiated_page.name).each do |page|
      cache_page page.to_s, "#{ page.path }.html"
    end
    send_file "#{ Rails.public_path }/#{ negotiated_page.path }.html",
      :type => 'text/html'
  rescue ActiveRecord::RecordNotFound
    request_path != '/404' ? redirect_to('/404') : render_404
  end

  protected
  def no_assets
    ASSETS.include? File.extname(request_path) and
    render :nothing => true, :status => 404
  end
  before_filter :no_assets

end
