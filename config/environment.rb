require "#{ File.dirname __FILE__ }/boot"
require "#{ File.dirname __FILE__ }/../lib/preferences"
require "#{ File.dirname __FILE__ }/../lib/preferences/farm_facts"

def session_secret
  require 'digest/sha1'
  session_secret_path = File.join Rails.root, 'config', 'session.key'

  unless File.exists? session_secret_path
    STDERR.puts "Generating a session secret in #{ session_secret_path }, this file should not be world-readable!"
    File.open session_secret_path, 'w' do |file|
      file << Digest::SHA1.hexdigest(Time.now.to_s << rand.to_s)
      file << Digest::SHA1.hexdigest(Time.now.to_s << rand.to_s)
    end
  end

  File.read session_secret_path
end

Rails::Initializer.run do |config|

  config.frameworks -= [ :active_resource ]

  config.gem 'haml'

  config.gem 'rr'
  config.gem 'thoughtbot-factory_girl',
      :lib    => 'factory_girl',
      :source => 'http://gems.github.com'

  config.load_paths += [
    %w[ app sweepers ],
  ].map! { |p| Rails.root.join *p }

  # config.active_record.observers = :garbage_collector
  # config.log_level = :debug

  config.time_zone = 'UTC'

  config.action_controller.allow_forgery_protection = false
  config.action_controller.session = {
    :session_key => 'farmfacts',
    :secret      => session_secret
  }
  config.action_view.sanitized_allowed_attributes = 'name', 'class'

end
