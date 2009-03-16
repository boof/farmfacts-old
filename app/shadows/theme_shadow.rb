class ThemeShadow < Shadows::Base

  def head(locals)
    locals.merge! :theme => @origin
    render_shape "#{ @origin.name }/head", :locals => locals
  end

  def themed_navigation(page, tmpl = :root, level = 0)
    buffer, index = '', 0

    if root = Navigation.roots.find_by_locale(page.locale)
      route = root.route_to_path page.path

      stack = [ [ tmpl, root, route, level ] ]

      while index < stack.length
        navigation stack, index, buffer
        index += 1
      end
    end

    buffer
  end
  def navigation(stack, index, buffer)
    buffer << case stack[index]
    when Array
      tmpl, root, route, level = stack[index]

      locals = {
        :root         => root,
        :active_route => route,
        :level        => level,
        :stack        => stack,
        :stack_index  => index
      }

      render_shape("#{ @origin.name }/navigations/#{ tmpl }", :locals => locals)
    when String
      stack[index]
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
