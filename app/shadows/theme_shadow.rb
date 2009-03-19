class ThemeShadow < Shadows::Base

  def head(locals)
    locals.merge! :theme => @origin
    render_shape "#{ @origin.name }/head", :locals => locals
  end

  def themed_navigation(page, template = :root)
    NavigationStack.render @origin, page, template
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

  class NavigationStack < Array

    def self.render(*args)
      new(*args).render
    end

    attr_reader :route, :position

    def initialize(theme, page, template = :root)
      @theme, @position = theme, 0

      if root = Navigation.roots.find_by_locale(page.locale)
        @route = root.route_to_path page.path
        self << [ template, root, 0 ]
      end
    end

    def render(out = '')
      while position < length
        out << case item = current
        when Array
          template, root, level = item
          render_navigation template, :root => root, :level => level
        when String
          item
        end

        @position += 1
      end

      out
    end

    def next=(item)
      self.insert @position + 1, item
    end

    def render_navigation(template, locals)
      locals = locals.merge :stack => self

      @theme.to_s :render_shape,
        "#{ @theme.name }/navigations/#{ template }", :locals => locals
    end
    protected
    def current
      at @position
    end

  end

end
