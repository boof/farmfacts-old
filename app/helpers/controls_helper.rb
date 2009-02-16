module ControlsHelper

  def render_pagination(scope, window = 2)
    limit, offset = scope.proxy_options.values_at(:limit, :offset)
    limit   ||= 10
    offset  ||= 0
    pagination = {}

    current_page = 1 + offset / limit
    lower = current_page - window
    if lower <= 1 then lower = 1
    else
      pagination[1] = link_to 1, :page => 1
      pagination[lower - 1] = link_to '&hellip;', :page => lower - 1 if lower > 2
    end

    page_count = scope.proxy_scope.count / limit
    upper = current_page + window
    if upper >= page_count then upper = page_count
    else
      pagination[page_count - 1] = link_to '&hellip;', :page => upper + 1 if upper + 1 < page_count
      pagination[page_count] = link_to page_count, :page => page_count
    end
    
    (lower..upper).each { |i| pagination[i] ||= link_to i, :page => i }
    pagination[current_page] = content_tag :strong, current_page

    content = []
    for index in pagination.keys.sort
      content << pagination[index]
    end
    content_tag :div, content * '&nbsp;', :class => 'pagination'
  end

  def location_to(caption, path)
    button_to_function caption, "window.location = '#{ path }'"
  end
  def back_to(path, caption = 'Back')
    location_to caption, path
  end
  def back_to_referrer(caption = 'Back')
    back_to url_for(:back), caption
  end

  def select_bulk_action(*options)
    options.map! { |option| ["#{ option }", "bulk_#{ option.underscore }"] }
    select_tag :bulk_action, options_for_select(options)
  end

  def render_attachment_controls_for(record)
    record_path = polymorphic_path [:admin, record]
    attachment  = record.attachments.new

    render :partial => 'admin/attachments/attachment', :collection => record.attachments,
        :layout => 'admin/attachments/controls',
        :locals => { :attachment => attachment, :record_path => record_path }
  end

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

end
