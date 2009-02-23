class Pagification::Metatags
  include Enumerable

  def metadata
    @data
  end
  def metadata=(data)
    @data = data.to_hash
  end

  def initialize(data)
    self.metadata = data || {}
  end

  def [](key)
    metadata[key]
  end
  def []=(key, value)
    metadata[key] = value
  end

  def each
    raise ArgumentError unless block_given?
    metadata.each { |k, v| yield MetaTag.new(k, v) unless v.blank? }
  end

  def to_s
    inject('') { |buf, tag| buf << tag.to_s }
  end

  # Builder for meta tags.
  module MetaTag

    @classes = {}
    def self.register(tag_name, class_object)
      @classes[tag_name] = class_object
    end
    def self.new(tag_name, value)
      @classes[tag_name].new value
    end

    class Name
      include ActionView::Helpers::TagHelper
      def initialize(name, content)
        @name, @content = name, content
      end
      def to_s
        tag :meta, :name => @name, :content => @content
      end
    end
    class Keywords < Name
      MetaTag.register 'keywords', self
      def initialize(keywords) super 'keywords', keywords end
    end
    class Description < Name
      MetaTag.register 'description', self
      def initialize(description) super 'description', description end
    end
    class Author < Name
      MetaTag.register 'author', self
      def initialize(author) super 'author', author end
    end
    class Publisher < Name
      MetaTag.register 'publisher', self
      def initialize(publisher) super 'publisher', publisher end
    end
    class Copyright < Name
      MetaTag.register 'copyright', self
      def initialize(copyright) super 'copyright', copyright end
    end
    class HttpEquiv
      include ActionView::Helpers::TagHelper
      def initialize(equiv, content)
        @equiv, @content = equiv, content
      end
      def to_s
        tag :meta, :'http-equiv' => @equiv, :content => @content
      end
    end
    class ContentType < HttpEquiv
      MetaTag.register 'content_type', self

      def initialize(type, opts = {})
        super 'content-type', opts.inject(type) { |mem, (opt, val)| "#{ mem }; #{ opt }=#{ val }" }
      end
    end
    class Charset < ContentType
      MetaTag.register 'charset', self
      def initialize(charset) super 'text/html', :charset => 'utf-8' end
    end
    class ContentLanguage < HttpEquiv
      MetaTag.register 'language', self
      def initialize(language) super 'content-language', language end
    end
  end

end
