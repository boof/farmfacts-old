class Mailer < ActionMailer::Base

  def announcement(announcer, recipient, subject, body)
    # TODO send mails plain and html                                
    self.recipients [recipient]
    self.from       announcer.email
    self.subject    subject

    self.body       :body => body
  end

end
