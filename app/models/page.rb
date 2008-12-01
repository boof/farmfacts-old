class Page < ActiveRecord::Base

  extend Page::Finder
  extend Bulk::Destroy
#  extend Bulk::Publication

  on_whitelist :updates => :updated_on
  has_many :comments, :as => :commented, :dependent => :delete_all

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

  def to_html
    RedCloth.new(body).to_html
  end

  protected
  def slash_path
    path.insert 0, '/' if path[0, 1] != '/'
  end
  before_save :slash_path

end
