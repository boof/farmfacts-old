desc 'Publishes a page.'
task :publish => :environment do
  ENV['PAGES'].split.each do |name|
    page = Page.find_by_path("/#{ name.strip }") and page.onlist.accept
  end
end