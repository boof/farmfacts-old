class Admin::ThemesController < Admin::Base

  Theme.source_path = Rails.root.join 'vendor', 'themes'

  def list
    themes_list = Theme.available.sort!
    themes_list.render
  end
  alias_method :index, :list

  def preview
    preview_page = Theme.preview params[:name]
    preview_page.render
  end
  alias_method :show, :preview

  def install
    Theme.install params[:name]
    return_or_redirect_to admin_themes_path
  end
  alias_method :create, :install

  def uninstall
    Theme.uninstall params[:name]
    return_or_redirect_to admin_themes_path
  end
  alias_method :destroy, :uninstall

end
