class Page < ActiveRecord::Base

  extend Page::Finder
  extend Bulk::Destroy
  extend Bulk::Onlist

  on_whitelist :updates => :updated_at
  categorizable
  registers_path { |page| page.path }

  has_many :attachments, :as => :attaching, :dependent => :delete_all

  named_scope :with_path, proc { |path| {:conditions => {:path => path}} }

  validates_uniqueness_of :path
  validates_presence_of :title, :body

  def not_found?
    path == '/not_found'
  end
  def homepage?
    path == '/home'
  end

  def to_s
    title
  end

  def self.default
    new do |instance|
      instance.title = Preferences::FarmFacts.name
      instance.stylesheets = [
        StyleSheet.new('blueprint/screen'),
        StyleSheet.new('blueprint/print', 'print'),
        StyleSheet::IE.new('blueprint/ie'),
        StyleSheet.new('application')
      ]
      instance.metadata = [
        Meta::ContentType.new('text/html', :charset => 'utf-8'),
        Meta::ContentLanguage.new('en')
      ]
    end
  end

  # TODO: Implement attributes.
  attr_accessor :stylesheets, :javascripts, :metadata

  protected
  def slash_path
    path.insert 0, '/' if path[0, 1] != '/'
  end
  before_save :slash_path

  class StyleSheet
    def initialize(path, *media)
      path.insert 0, '/stylesheets/' if path[0, 1] != '/'
      path << '.css' if path[-4, 4] != '.css'
      media = %w[ screen projections ] if media.blank?

      @path, @media = path, media * ', '
    end
    def to_s
      %Q'<link rel="stylesheet" href="#{ @path }" type="text/css" media="#{ @media }" />'
    end
    class IE < StyleSheet
      def to_s
        "<!--[if IE]>#{ super }<![endif]-->"
      end
    end
  end
  module Meta
    class Name
      def initialize(name, content)
        @name, @content = name, content
      end
      def to_s
        %Q'<meta name="#{ @name }" content="#{ @content }" />'
      end
    end
    class Keywords < Name
      def initialize(*words)
        super 'keywords', words * ', '
      end
    end
    class Description < Name
      def initialize(description)
        super 'description', description
      end
    end
    class HttpEquiv
      def initialize(equiv, content)
        @equiv, @content = equiv, content
      end
      def to_s
        %Q'<meta http-equiv="#{ @equiv }" content="#{ @content }" />'
      end
    end
    class ContentLanguage < Name
      def initialize(language)
        super 'content-language', language
      end
    end
    class ContentType < HttpEquiv
      def initialize(content, options = {})
        options.each { |option, value| content << "; #{ option }=#{ value }" }
        super 'content-type', content
      end
    end
  end

end
