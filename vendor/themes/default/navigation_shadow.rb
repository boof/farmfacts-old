def render_navigation(*args, &block)
  html_options  = {:class => 'navigation'}.merge args.extract_options!
  html_options[:class].include? 'navigation' or
  html_options[:class] << ' navigation'
  root          = args.shift

  if block
    navigation = NavigationRenderer.render capture(&block), self
    concat content_tag(:div, navigation, html_options)
  else
    navigation = NavigationRenderer.render root, self
    content_tag(:div, navigation, html_options)
  end
end

class NavigationRenderer
  attr_accessor :content

  def self.render(data, template)
    instance = new template

    case data
    when String
      instance.content = data
    when ActiveRecord::Base
      instance.load_tree data
    when Array
      instance.load_list data
    when nil
      instance.content = template.render :file => "#{ Rails.root }/app/views/shared/navigation.html.haml"
    end

    instance.content
  end

  def initialize(template)
    @tmpl = template
  end

  def load_tree(record)
    raise NotImplementedError
  end
  def load_list(array)
    @content = array.map { |el|
      anchor = link_to h(el.label), el.path
      content_tag :li, anchor, :class => 'column'
    }.to_s
  rescue NoMethodError
    raise ArgumentError, 'expected element to respond to :label and :path'
  end

  protected
  def h(*args)
    @tmpl.h(*args)
  end
  def link_to(*args)
    @tmpl.link_to(*args)
  end
  def content_tag(*args)
    @tmpl.content_tag(*args)
  end
end
