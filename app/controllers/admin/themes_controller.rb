class Admin::ThemesController < Admin::Base

  def index
    current.title = 'Themes'
    @themes = Theme.available.values.sort_by { |theme| theme.name }
  end

  # FIXME: Works only for installed themes.
  def show
    theme = Theme.available.fetch params[:name]

    page = ThemedPage.new do |p|
      p.theme     = theme
      p.elements  = theme.elements
      p.metadata  = Preferences[:FarmFacts].metadata
    end

    page.build_pagification(:pagified => page).generate_page.render :preview
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
