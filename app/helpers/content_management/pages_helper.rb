module ContentManagement::PagesHelper
  
  def link_to_publish_or_revoke(page)
    if page.publication && !page.publication.revoked?
      link_to image_tag('icons/page_tick.gif'),
        revoke_content_management_page_path(page),
        :method => :post, :confirm => "Revoke '#{ page.name }'?",
        :title => "Published at #{ page.publication.updated_at }."
    else
      link_to image_tag('icons/page_deny.gif'),
        publish_content_management_page_path(page),
        :method => :post, :confirm => "Publish '#{ page.name }'?",
        :title => 'Not published.'
    end
  end
  
  def index_button(caption)
    button_to_function caption,
      "window.location = '#{content_management_pages_path}'"
  end
  
  def preview_button(caption)
    button_to_function caption, remote_function(
      :update => :preview,
      :url    => preview_content_management_pages_path,
      :with   => 'Form.Element.serialize("page_body_markdown")'
    )
  end
  
end
