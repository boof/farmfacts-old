class ThemedPage::ElementShadow < ThemeShadow

  def form(locals)
    render_shape "#{ @origin.pathname.to_s[/vendor\/themes(.+)/, 1] }_form", :locals => locals
  end

end
