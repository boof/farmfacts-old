class Announce < ActionMailer::Base
  
  def article(editor, recipient, article, prefix = '[ANN] ')
    recipients recipient
    from       editor.email
    subject    prefix + article.title
    body       :article => article
  end
  
end
