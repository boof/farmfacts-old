class PageSweeper < ActionController::Caching::Sweeper
  observe Page

  # thanks Rails for its consistency...
  PUBLIC_PATH = Pathname.new Rails.public_path

  def before_update(page)
    @page_name = page.name_changed?? page.name_was : page.name
  end
  def after_create(page)
    expire_index if page.index?
  end

  def default_expire(page)
    expire_index if page.index?

    expire_page "/#{ name_of page }.html"
    each_l10n(name_of(page)) { |pp| expire_page pp }
  end
  alias_method :after_update, :default_expire
  alias_method :after_destroy, :default_expire
  alias_method :when_accepted, :default_expire
  alias_method :when_rejected, :default_expire

  protected
  def expire_index
    expire_page '/index.html'
    each_l10n('index') { |pp| expire_page pp }
  end

  def name_of(page)
    @page_name || page.name
  end

  def each_l10n(name)
    Pathname.glob("#{ File.join Rails.public_path, name }.*.html").
    each { |pathname| yield "/#{ pathname.relative_path_from PUBLIC_PATH }" }
  end

end
