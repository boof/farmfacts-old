module ApplicationHelper

  def humanized_size(size)
    if (1.kilobyte ... 1.megabyte).include? size
      '%.2fkb' % (size.to_f / 1.kilobyte)
    elsif (1.megabyte ... 1.gigabyte).include? size
      '%.2fgb' % (size.to_f / 1.megabyte)
    else
      '%i bytes' % size
    end
  end

  def eo(index, offset = 0, *classes)
    classes = %w[ even odd ] if classes.empty?
    modulo  = classes.length

    classes.at index % modulo + offset % modulo
  end

  module Deprecated
    LAST_MODIFIED = '<span class="quiet">Last modified:</span> %s'
    def last_modified(timestamp = nil)
      LAST_MODIFIED % relative_date(timestamp) if timestamp
    end
    RELATIVE_DATE = '<span class="relative_date">%s</span>'
    def relative_date(timestamp = nil)
      timestamp ||= @modified_at
      RELATIVE_DATE % timestamp.to_formatted_s if timestamp
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
  include Deprecated

end
