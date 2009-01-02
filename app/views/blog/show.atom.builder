atom_feed :root_url => "#{ request.protocol }#{ request.host }#{ request.port_string }#{ blog_path @article }" do |feed|
  feed.title @article.title
  feed.updated @article.updated_at

  @comments.each do |comment|
    feed.entry comment, :url => "#{ request.protocol }#{ request.host }#{ request.port_string }#{ blog_path @article }#comment_#{ comment.id }" do |entry|
      entry.title "#{ comment.author } replied:"
      entry.content comment.message
      entry.author do |author|
        author.name comment.author
        author.uri comment.url if comment.url
      end
    end
  end
end
