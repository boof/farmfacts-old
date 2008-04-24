module ContentManagement::NewsHelper
  
  def link_to_publish_or_revoke(article)
    if article.publication && !article.publication.revoked?
      link_to image_tag('icons/page_tick.gif'),
        revoke_content_management_news_path(article),
        :method => :post, :confirm => "Revoke '#{ article.title }'?",
        :title => "Published at #{ article.publication.updated_at }."
    else
      link_to image_tag('icons/page_deny.gif'),
        publish_content_management_news_path(article),
        :method => :post, :confirm => "Publish '#{ article.title }'?",
        :title => 'Not published.'
    end
  end
  
end
