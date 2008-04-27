module CommentsHelper
  
  def remote_new_comment_button_to(caption, path)
    remote = remote_function(
      :before => '$(this).hide()',
      :method => :get,
      :url => path,
      :update => :comment
    )
    button = button_to_function caption, remote, :id => :new_comment_button
    
    button << content_tag(:div, nil, :id => :comment)
  end
  def link_to_remote_comments(caption, path)
    link = link_to_remote caption,
      :method => :get,
      :url => path,
      :update => :comments
    
    content_tag :div, link, :id => :comments
  end
  
end
