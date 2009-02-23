class Page < ActiveRecord::Base
  extend Finder

  extend Bulk::Destroy
  extend Bulk::Onlist

  on_whitelist :updates => :updated_at
  categorizable
  attach_shadows :assign => :attributes

  validates_presence_of :path
  validates_uniqueness_of :path

  has_one :pagification

  has_many :attachments, :as => :attaching, :dependent => :destroy
  delegate :javascripts, :stylesheets, :images, :to => :attachments

  def not_found?
    path[0, 4] == '/404'
  end
  def index?
    path == Preferences['FarmFacts'].frontpage_path
  end

  protected
  def sanitize_path
    self.path = "/#{ path }" unless path.blank? or path[0, 1] == '/'
  end
  before_validation :sanitize_path

end
