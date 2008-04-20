module ContentManagement::PluginsHelper
  
  BEFORE_AJAX = %q[$('%s').show();]
  AFTER_AJAX = %q[$(this).writeAttribute({onclick:'$(\\'%s\\').toggle();'})]
  
  def remote_feed_for(plugin)
    receiver_id = "feed_of_plugin_#{plugin.id}"
    receiver = content_tag :div, '', :id => receiver_id,
      :style => 'display: none;'
    
    options = {
      :before => BEFORE_AJAX % receiver_id,
      :method => :get,
      :url    => plugin_feed_path(plugin),
      :update => receiver_id,
      :after  => AFTER_AJAX % receiver_id
    }
    
    link_to_remote(plugin.feed_path, options) << receiver
  end
  
end
