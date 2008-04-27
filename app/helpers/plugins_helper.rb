module PluginsHelper
  
  def remote_plugin_feed(plugin, e_id = 'injectedBox')
    unless plugin.feed_path.blank?
      remote_params = {
        :method => :get,
        :url => plugin_feed_path(plugin),
        :update => e_id
      }
    
      content_tag :div, :id => e_id do
        content_tag(:p, JS_REQUIRED_MSG, :class => 'noJS') <<
        javascript_tag { remote_function remote_params }
      end
    end
  end
  
end
