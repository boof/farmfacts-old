atom_feed :root_url => "#{ request.protocol }#{ request.host }#{ request.port_string }#{ blog_index_path }" do |feed|
  feed.title "#{ page_title } [#{ APPLICATION_NAME }]"
  feed.updated @articles.first.try(:updated_at) || Time.now

  @articles.each do |article|
    feed.entry article, :url => "#{ request.protocol }#{ request.host }#{ request.port_string }#{ blog_path article }" do |entry|
      entry.title article.title
      entry.content textile(article.teaser.blank?? article.body : article.teaser), :type => 'html'
      entry.author do |author|
        author.name article.author.name
        author.uri article.author.website if article.author.website
      end
    end
  end
end
