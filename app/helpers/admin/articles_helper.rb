module Admin::ArticlesHelper
  
  def link_to_publish_or_revoke(article)
    if article.publication
      link_to image_tag('icons/page_tick.gif'),
        revoke_admin_article_path(article),
        :method => :post, :confirm => "Revoke '#{ article }'?",
        :title => "Published at #{ article.publication.updated_at }."
    else
      link_to image_tag('icons/page_deny.gif'),
        publish_admin_article_path(article),
        :method => :post, :confirm => "Publish '#{ article }'?",
        :title => 'Not published.'
    end
  end
  
  def index_button(caption)
    button_to_function caption,
      "window.location = '#{ admin_articles_path }'"
  end
  
end
