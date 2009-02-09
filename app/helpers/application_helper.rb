module ApplicationHelper

  class StyleSheet
    def initialize(path, *media)
      path.insert 0, /stylesheets/ if path[0, 1] != '/'
      path << '.css' if path[-4, 4] != '.css'
      media = %w[ screen projections ] if media.blank?

      @path, @media = path, media * ', '
    end
    def to_s
      %Q'<link rel="stylesheet" href="#{ @path }" type="text/css" media="#{ @media }">'
    end
    class IE < StyleSheet
      def to_s
        "<!--[if IE]>#{ super }<![endif]-->"
      end
    end
  end
  module Meta
    class Name
      def initialize(name, content)
        @name, @content = name, content
      end
      def to_s
        %Q'<meta name="#{ @name }" content="#{ @content }" />'
      end
    end
    class Keywords < Name
      def initialize(*words)
        super 'keywords', words * ', '
      end
    end
    class Description < Name
      def initialize(description)
        super 'description', description
      end
    end
    class HttpEquiv
      def initialize(equiv, content)
        @equiv, @content = equiv, content
      end
      def to_s
        %Q'<meta http-equiv="#{ @equiv }" content="#{ @content }" />'
      end
    end
    class ContentType < HttpEquiv
      def initialize(content, options = {})
        options.each { |option, value| content << "; #{ option }=value" }
        super 'content-type', content
      end
    end
  end

  def page
    @page ||= Page.new do |p|
      p.title = @page_title || DEFAULT_TITLE
      p.stylesheets = [
        StyleSheet.new('blueprint/screen'),
        StyleSheet.new('blueprint/print', 'print'),
        StyleSheet::IE.new('blueprint/ie'),
        StyleSheet.new('application')
      ]
      keywords = ( @page_keywords || DEFAULT_KEYWORDS ).
        split(',').each { |keyword| keyword.strip! }
      description = @page_description || DEFAULT_DESCRIPTION
      p.metadata = [
        Meta::ContentType.new('text/html', :charset => 'utf-8')
        Meta::Keywords.new(*keywords),
        Meta::Description.new(description)
      ]
    end
  end

  def humanized_size(size)
    if (1.kilobyte ... 1.megabyte).include? size
      '%.2fkb' % (size.to_f / 1.kilobyte)
    elsif (1.megabyte ... 1.gigabyte).include? size
      '%.2fgb' % (size.to_f / 1.megabyte)
    else
      '%i bytes' % size
    end
  end

  def odd(index, offset = 0, *classes)
    classes = %w[ even odd ] if classes.empty?
    modulo  = classes.length

    classes.at index % modulo + offset % modulo
  end

  JS_INCLUDES = %w[ sh/shCore
    sh/shBrushCSharp sh/shBrushPhp sh/shBrushJScript sh/shBrushJava
    sh/shBrushVb sh/shBrushSql sh/shBrushXml sh/shBrushDelphi sh/shBrushPython
    sh/shBrushRuby sh/shBrushCss sh/shBrushCpp sh/shBrushScala
    sh/shBrushGroovy sh/shBrushBash ]
  def syntaxhighlighter
    opts = JS_INCLUDES + [{:cache => 'syntaxhighlighter'}]
    stylesheet_link_tag('syntaxhighlighter') + javascript_include_tag(*opts)
  end

end
