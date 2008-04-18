module HomeHelper
  
  def remote_list_of_plugins(e_id = 'listOfPlugins')
    remote_params = {:update => e_id, :url => plugins_path, :method => :get}
    
    content_tag :div, :id => e_id do
      javascript_tag { remote_function remote_params }
    end
  end
  
end
