class ThemedPage::ElementShadow < ThemeShadow

  def icon
    @origin.icon.to_s
  end
  def form(locals = {})
    render_shape "#{ @origin.pathname.to_s[/vendor\/themes(.+)/, 1] }_form", :locals => locals
  end
  def completed
    render_shape "#{ @origin.pathname.to_s[/vendor\/themes(.+)/, 1] }"
  end
  def sketch(locals = {})
    render_shape "#{ @origin.pathname.to_s[/vendor\/themes(.+)/, 1] }_sketch", :locals => locals
  end

end
