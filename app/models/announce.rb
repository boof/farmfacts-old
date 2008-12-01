class Announce < ActionMailer::Base

  def article(announcer, recipient, subject, body)
    self.recipients [recipient]
    self.from       announcer.email
    self.subject    subject

    self.body       :body => body
  end

end
