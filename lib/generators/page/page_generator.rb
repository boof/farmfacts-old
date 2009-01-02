class PageGenerator < Rails::Generator::Base
  def manifest
    raise ArgumentError, 'No name given!' if @args.empty?
    record do |m|
      ActiveRecord::Base.transaction do
        name      = @args.pop.gsub(/\.textile$/, '')
        path      = File.join File.expand_path(@args.shift || Dir.getwd), "#{ name }.textile".split('/')
        title     = name.titleize

        page = Page.new :path => "/#{ name }", :title => title, :body => File.read(path)

        if page.save
          puts "Successfully created page #{ title } from #{ path }."
        else
          puts "Failed to create page #{ title } from #{ path }."
        end
      end
    end
  end
end
