module ApplicationHelper

  def page_title
    @page_title || 'Ruby Sequel - The Database Toolkit for Ruby'
  end

  def inject_box(path, e_id = 'injectedBox')
    function = remote_function :update => e_id, :url => path, :method => :get

    content_tag :div, :id => e_id do
      content_tag(:p, JS_REQUIRED_MSG, :class => 'noJS') <<
      javascript_tag(function)
    end
  end

end
