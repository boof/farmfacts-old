class ThemeShadow < Shadows::Base

  def head(locals)
    locals.merge! :theme => @origin
    render_shape "#{ @origin.name }/head", :locals => locals
  end
  def body(locals)
    locals.merge! :theme => @origin
    render_shape "#{ @origin.name }/body", :locals => locals
  end

  protected
  def themes_path
    Theme.path
  end
  def _load_paths
    super + [ themes_path.to_s ]
  end

end
