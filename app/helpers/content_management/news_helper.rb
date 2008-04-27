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
  
  def index_button(caption)
    button_to_function caption,
      "window.location = '#{content_management_news_index_path}'"
  end
  
  def preview_button(caption)
    button_to_function caption, remote_function(
      :update => :preview,
      :url    => preview_content_management_news_path,
      :with   => 'Form.Element.serialize("article_content_markdown")'
    )
  end
  
end
