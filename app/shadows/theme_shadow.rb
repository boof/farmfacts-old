class ThemeShadow < Shadows::Base

  def head(locals)
    locals.merge! :theme => @origin
    render_shape "#{ @origin.name }/head", :locals => locals
  end

=begin
  # set css class in Shadow
  if active_route.include? self
    # render self
    # dive into children
  else
    # render self
  end
=end

  def navigation(locals)
    locals[:level] ||= 0
    locals[:root] ||= locals[:page].navigation

    unless locals[:root].blank?
      locals[:active_route] ||= locals[:root].route_by_path locals[:page].path

      case @origin.navigation
      when 'infinite'
        render_shape "#{ @origin.name }/navigations/level-n", :locals => locals
      when 'finite'
        render_shape "#{ @origin.name }/navigations/level-#{ locals[:level] }", :locals => locals
      end

    end
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
