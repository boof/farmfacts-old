class Announce < ActionMailer::Base
  
  def article(editor, recipients, subject, body)
    self.recipients recipients.split(',')
    self.from       editor.email
    self.subject    subject
    
    self.body       :body => body
  end
  
end
