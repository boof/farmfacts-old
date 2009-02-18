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

  validates_uniqueness_of :compiled_path
  validates_presence_of :title, :body

  has_many :attachments, :as => :attaching, :dependent => :destroy
  has_many :javascripts, :as => :attaching, :class_name => 'Attachment', :conditions => ['attachments.type IN (?)', %w[ Attachment::Javascript ]]
  has_many :stylesheets, :as => :attaching, :class_name => 'Attachment', :conditions => ['attachments.type IN (?)', %w[ Attachment::Stylesheet Attachment::Stylesheet::IE ]]

  serialize :metadata, Hash
  composed_of :metatags, :class_name => 'Page::Metatags',
    :mapping => %w[metadata],
    :converter => proc { |data| Metatags.new data }

  def self.default
    new do |page|
      page.title = Preferences::FarmFacts.name
      page.stylesheets = [
        ::Attachment::Stylesheet.fake('blueprint/screen'),
        ::Attachment::Stylesheet.fake('blueprint/print', 'print'),
        ::Attachment::Stylesheet::IE.fake('blueprint/ie'),
        ::Attachment::Stylesheet.fake('application')
      ]
      page.metadata = {'charset' => 'utf-8', 'language' => 'en'}
    end
  end

  def not_found?
    compiled_path[1, 3] == '404'
  end
  def index?
    frontpage_path = Preferences['FarmFacts'].frontpage_path
    compiled_path[1, frontpage_path.length] == frontpage_path
  end

  protected
  def compile_path
    write_attribute :compiled_path, path.dup
    compiled_path.insert 0, '/' if path[0, 1] != '/'
    compiled_path.concat ".#{ metadata['language'] }"
  end
  before_validation :compile_path

end
