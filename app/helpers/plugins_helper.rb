module PluginsHelper
  
  def remote_commits_feed(plugin, e_id = 'injectedBox')
    remote_params = {
      :method => :get,
      :url => plugin_feed_path(plugin),
      :update => e_id
    }
    
    content_tag :div, :id => e_id do
      content_tag(:p, 'You must enable javascript to see the latest plugin commits.', :class => 'noJS') <<
      javascript_tag { remote_function remote_params }
    end
  end
  
end
