if ActiveRecord::Base.configurations[Rails.env]['adapter'] =~ /sqlite/
  require 'rubygems'
  gem 'sqlite3-ruby'
  require 'sqlite3'
end
