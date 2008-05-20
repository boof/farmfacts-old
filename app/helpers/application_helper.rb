module ApplicationHelper
  
  def page_title
    @page_title || 'Ruby Sequel - The Database Toolkit for Ruby'
  end
  
  def inject_box(path, e_id = 'injectedBox')
    remote_params = {:update => e_id, :url => path, :method => :get}
    
    content_tag :div, :id => e_id do
      content_tag(:p, JS_REQUIRED_MSG, :class => 'noJS') <<
      javascript_tag { remote_function remote_params }
    end
  end
  
end
