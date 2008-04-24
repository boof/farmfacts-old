module NewsHelper
  
  def remote_commits_feed(e_id = 'injectedBox')
    remote_params = {:update => e_id, :url => commits_path, :method => :get}
    
    content_tag :div, :id => e_id do
      content_tag(:p, 'You must enable javascript to see the latest plugin commits.', :class => 'noJS') <<
      javascript_tag { remote_function remote_params }
    end
  end
  
end
