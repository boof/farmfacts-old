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
    compiled_path[1, 3] == '404'
  end
  def index?
    frontpage_path = Preferences['FarmFacts'].frontpage_path
    compiled_path[1, frontpage_path.length] == frontpage_path
  end

  serialize :metadata, Hash
  composed_of :metatags, :class_name => 'Page::Metatags',
    :mapping => %w[metadata],
    :converter => proc { |data| Metatags.new data }

  def self.default
    new do |page|
      page.title = Preferences::FarmFacts.name
      page.stylesheets = [
        Stylesheet.fake('blueprint/screen'),
        Stylesheet.fake('blueprint/print', 'print'),
        Stylesheet::IE.fake('blueprint/ie'),
        Stylesheet.fake('application')
      ]
      page.metadata = {'charset' => 'utf-8', 'language' => 'en'}
    end
  end

  attr_writer :stylesheets, :javascripts

  def stylesheets
    @stylesheets ||= attachments.scoped :conditions => ['attachments.type = ?', 'Stylesheet%'], :order => 'position'
  end
  def stylesheet_links
    stylesheets.map { |s| s.to_s :link }
  end
  def javascripts
    @javascripts ||= attachments.scoped :conditions => { :type => 'Javascript' }, :order => 'position'
  end

  protected
  def compile_path
    write_attribute :compiled_path, path.dup
    compiled_path.insert 0, '/' if path[0, 1] != '/'
    compiled_path.concat ".#{ metadata['language'] }"
  end
  before_validation :compile_path


end
