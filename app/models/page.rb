class Page < ActiveRecord::Base

  extend Page::Finder
  extend Bulk::Destroy
  extend Bulk::Onlist

  on_whitelist :updates => :updated_at
  categorizable
  registers_path { |page| page.path }

  has_many :comments, :as => :commented, :dependent => :delete_all
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

  protected
  def slash_path
    path.insert 0, '/' if path[0, 1] != '/'
  end
  before_save :slash_path

end
