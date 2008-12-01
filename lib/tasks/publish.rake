desc 'Publishes a page.'
task :publish => :environment do
  ENV['PAGES'].split.each do |name|
    page = Page.find_by_name("/#{ name.strip }") and page.create_publication
  end
end