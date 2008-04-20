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
  
end
