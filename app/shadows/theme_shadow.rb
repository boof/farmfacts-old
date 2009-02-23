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
  def _load_paths
    super + [ Theme.path.to_s ]
  end

end
