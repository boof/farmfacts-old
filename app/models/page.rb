class Page < ActiveRecord::Base
  extend Finder

  extend Bulk::Destroy
  extend Bulk::Onlist

  on_whitelist :updates => :updated_at
  categorizable
  attach_shadows :assign => :attributes
  registers_path :scope => proc { |p| p.locale }, :label => proc { |p| p.name }, :path => proc { |p| p.path }

  def navigation
    Navigation.find_by_locale locale
  end

  validates_presence_of :name
  validates_uniqueness_of :path

  has_one :pagification, :dependent => :destroy

  has_many :attachments, :as => :attaching, :dependent => :destroy
  delegate :javascripts, :stylesheets, :images, :to => :attachments

  def self.negotiate(request, scope = :accepted)
    negotiator = Negotiator.new request, send(scope)
    negotiator.negotiate
  end

  def not_found?
    name == '404'
  end
  def index?
    name == Preferences['FarmFacts'].frontpage_name
  end

  def pagified?
    !pagification.nil?
  end
  def pagify
    pagification.pagified.pagify
  end

  def generate_path
    unless name.blank? or not name_or_locale_changed?
      path_will_change!
      self.path = "/#{ name }"
      self.path << ".#{ locale }" unless locale.blank?
    end
  end
  protected
  def sanitize_name
    unless name.blank? or name[0, 1] != '/'
      name_will_change!
      name.slice! 0, 1
    end
  end
  before_validation :sanitize_name, :generate_path

  def name_or_locale_changed?
    name_changed? or locale_changed?
  end

end
