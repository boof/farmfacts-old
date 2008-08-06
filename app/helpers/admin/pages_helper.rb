module Admin::PagesHelper
  
  def link_to_publish_or_revoke(page)
    if page.publication
      link_to image_tag('icons/page_tick.gif'),
        revoke_admin_page_path(page),
        :method => :post, :confirm => "Revoke '#{ page }'?",
        :title => "Published at #{ page.publication.updated_at }."
    else
      link_to image_tag('icons/page_deny.gif'),
        publish_admin_page_path(page),
        :method => :post, :confirm => "Publish '#{ page }'?",
        :title => 'Not published.'
    end
  end
  
  def index_button(caption)
    button_to_function caption,
      "window.location = '#{ admin_pages_path }'"
  end
  
end
