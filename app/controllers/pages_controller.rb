class PagesController < ApplicationController
  # asset extensions that wont be delivered
  ASSETS = %w[ css flv gif jpeg jpg js png swf exe cgi pl php ].
      map! { |e| ".#{ e }" }

  def show
    if negotiated_page = Page.negotiate(request)
      Page.named(negotiated_page.name).each do |page|
        html = page.to_s
        cache_page html, "#{ page.path }.html"
        cache_page html, "/index#{ ".#{ page.locale }" if page.locale }.html" if page.index?
      end
      render :file => "#{ Rails.public_path }#{ negotiated_page.path }.html"
    elsif request.path != '/404'
      logger.info "Could not find #{ request.path } from #{ request.referer }."
      redirect_to '/404'
    else
      render_404
    end
  end

  def sitemap
    negotiator = Negotiator.new request, :name => 'sitemap'

    locale = negotiator.negotiate do |n|
      me_locales = n.locales & Navigation.roots.select_all(:locale)
      me_locales.first || Preferences[:FarmFacts].metadata['language']
    end

    root = Navigation.roots.l10n(locale).first
    @paths = (root.lft and root.rgt) ? root.full_set : [root]
    @paths.map! { |navigation| navigation.path unless navigation.path.blank? }
    @paths.compact!
  end

  protected
  def no_assets
    if ASSETS.include? File.extname(request.path)
      logger.info "Could not find #{ request.path } from #{ request.referer }."
      render :nothing => true, :status => 404
    end
  end
  before_filter :no_assets

end
