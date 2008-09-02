require File.join(File.dirname(__FILE__), 'boot')

require 'digest/sha1'
session_secret_path = File.join Rails.root, 'session_secret'
unless File.exists? session_secret_path
  File.open session_secret_path, 'w' do |file|
    file << Digest::SHA1.hexdigest(Time.now.to_s << rand.to_s)
    file << Digest::SHA1.hexdigest(Time.now.to_s << rand.to_s)
  end
end
session_secret = File.read session_secret_path

Rails::Initializer.run do |config|

  config.frameworks -= [ :active_resource ]

  config.gem 'sequel'
  config.gem 'maruku'
  config.gem 'memcache-client', :lib => 'memcache'

  config.gem 'uuidtools'
  config.gem 'feedtools', :lib => 'feed_tools'

  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  config.load_paths << File.join(Rails.root, %w[app sweepers])

  # config.log_level = :debug

  config.time_zone = 'UTC'

  config.action_controller.allow_forgery_protection = false
  config.action_controller.session = {
    :session_key => '_www-ruby-sequel-org_',
    :secret      => session_secret
  }

end
