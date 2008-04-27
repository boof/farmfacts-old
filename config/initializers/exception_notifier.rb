ExceptionNotifier.instance_eval do
  exception_recipients = %w[florian.assmann@oniversus.com]
  sender_address = %w[error@ruby-sequel.org]
  email_prefix = '[RUBY-SEQUEL] '
end
