class PageGenerator < Rails::Generator::Base
  def manifest
    raise ArgumentError, 'No name given!' if @args.empty?
    record do |m|
      ActiveRecord::Base.transaction do
        name      = @args.pop.gsub(/\.markdown$/, '')
        path      = File.join File.expand_path(@args.shift || Dir.getwd), "#{ name }.markdown".split('/')
        title     = name.titleize

        page = Page.new :name => name, :title => title, :body => File.read(path)

        if page.save
          puts "Successfully created page #{ title } from #{ path }."
        else
          puts "Failed to create page #{ title } from #{ path }."
        end
      end
    end
  end
end
