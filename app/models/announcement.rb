class Announcement
  extend ActionView::Helpers::SanitizeHelper::ClassMethods
  include ActionView::Helpers::SanitizeHelper
  include TextileHelper

  attr_accessor :html, :plain, :sender, :subject

  def attributes=(attributes)
    for key, value in attributes
      send "#{ key }=", value
    end
  end

  def attributes
    instance_variables.inject({}) do |mem, variable|
      mem.update variable.to_sym => instance_variable_get(variable)
    end
  end

  def initialize(attributes = {})
    attributes = { :recipients => MAILING_LISTS }.update attributes
    self.attributes = attributes
  end

  def recipients=(recipients)
    @recipients = recipients.split(', ').each { |r| r.strip! }
  end
  def recipients
    @recipients * ', '
  end

  def deliver
    for recipient in @recipients
      Mailer.deliver_announcement @sender, recipient, @title, @plain, @html
    end
  end

end
