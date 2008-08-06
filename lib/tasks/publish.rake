desc 'Publishes a page.'
task :publish => :environment do
  user = User.find :first, :joins => :login, :conditions => {'logins.username' => ENV['USER']}

  ENV['PAGES'].split.each do |name|
    user.publish 'Page', Page.find(:first, :conditions => {:name => "/#{ name.strip }"}, :select => :id).id
  end
end