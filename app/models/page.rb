class Page < ActiveRecord::Base
  extend Finder

  extend Bulk::Destroy
  extend Bulk::Onlist

  on_whitelist :updates => :updated_at
  attach_shadows :assigns => :attributes
  categorizable
  registers_path :label => proc { |page| page.title } do |page|
    page.compiled_path
  end

  has_many :attachments, :as => :attaching,
    :dependent => :destroy,
    :order => 'position'

  validates_uniqueness_of :compiled_path
  validates_presence_of :title, :body

  def not_found?
    path[1, 3] == '404'
  end
  def index?
    frontpage_path = Preferences['FarmFacts'].frontpage_path
    path[1, frontpage_path.length] == frontpage_path
  end

  serialize :metadata, Hash
  composed_of :metatags, :class_name => 'Page::Metatags',
    :mapping => %w[metadata],
    :converter => proc { |data| Metatags.new data }

  def self.default
    new do |page|
      page.title = Preferences::FarmFacts.name
      page.stylesheets = [
        StyleSheet.new('blueprint/screen'),
        StyleSheet.new('blueprint/print', 'print'),
        StyleSheet::IE.new('blueprint/ie'),
        StyleSheet.new('application')
      ]
      page.metadata = {'charset' => 'utf-8', 'language' => 'en'}
    end
  end

  # TODO: Implement attributes.
  attr_accessor :stylesheets, :javascripts

  protected
  def compile_path
    write_attribute :compiled_path, path.dup
    compiled_path.insert 0, '/' if path[0, 1] != '/'
    compiled_path.concat ".#{ metadata['language'] }"
  end
  before_validation :compile_path

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

end
