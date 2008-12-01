module ApplicationHelper

  def page_title
    @page_title || DEFAULT_TITLE
  end

  def page_keywords
    @page_keywords || DEFAULT_KEYWORDS
  end

  def page_description
    @page_keywords || DEFAULT_DESCRIPTION
  end

  def navigation
    File.read "#{ Rails.root }/app/views/shared/navigation.html"
  end

  def odd(index, offset = 0, *classes)
    classes = %w[ even odd ] if classes.empty?
    modulo  = classes.length

    classes.at index % modulo + offset % modulo
  end

  def link_to_textile(caption = 'Textile')
    function = 'window.open("http://en.wikipedia.org/wiki/Textile_(markup_language)")'

    link_to_function h(caption), function,
      :href   => 'http://en.wikipedia.org/wiki/Textile_(markup_language)',
      :title  => 'The single biggest source of inspiration for Markdown’s syntax is the format of plain text email.'
  end

end
