class Admin::ThemesController < Admin::Base

  def index
    current.title = 'Themes'
    @themes = Theme.available.values.sort_by { |theme| theme.name }
  end

  def install
    theme = Theme.not_installed.fetch params[:name]
    theme.save

    return_or_redirect_to admin_themes_path
  end

  def uninstall
    theme = Theme.installed.fetch params[:name]
    theme.destroy

    return_or_redirect_to admin_themes_path
  end

end
