class Page < ActiveRecord::Base
  extend Finder

  extend Bulk::Destroy
  extend Bulk::Onlist

  on_whitelist :updates => :updated_at
  categorizable
  attach_shadows :assign => :attributes

  validates_presence_of :name
  validates_uniqueness_of :path

  has_one :pagification

  has_many :attachments, :as => :attaching, :dependent => :destroy
  delegate :javascripts, :stylesheets, :images, :to => :attachments

  def not_found?
    name == '404'
  end
  def index?
    name == Preferences['FarmFacts'].frontpage_name
  end

  protected
  def sanitize_name
    unless name.blank? or name[0, 1] != '/'
      name_will_change!
      name.slice! 0, 1
    end
  end
  def generate_path
    unless name.blank? or not name_or_locale_changed?
      path_will_change!
      self.path = "/#{ name }"
      self.path << ".#{ locale }" unless locale.blank?
    end
  end
  before_validation :sanitize_name, :generate_path

  def name_or_locale_changed?
    name_changed? or locale_changed?
  end

end
