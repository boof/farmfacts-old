class User < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  extend Bulk::Destroy
  include Gravatar

  # Articles Extension
  # has_many :articles, :order => :title, :foreign_key => :author_id
  # Projects Extension
  # has_many :roles
  # has_many :works, :through => :roles

  has_one :login, :dependent => :destroy
  accepts_nested_attributes_for :login

  belongs_to :page

  validates_presence_of :name

  named_scope :except, proc { |*ids_or_records|
    ids = ids_or_records.map { |obj| obj.is_a?(User) ? obj.id : obj }
    { :conditions => ['users.id NOT IN (?)', ids] }
  }

  def authorized?
    not new_record?
  end

  def to_s
    name
  end

  def website
    local_path or remote_url
  end

  def self.authorized_by(params)
    login = Login.find_with_credentials params
    block_given?? yield(login.user) : login.user if login
  end

  def save_with_login(argument = nil)
    if argument then save_without_login argument
    else
      transaction do
        save_without_login and login.save or raise ActiveRecord::Rollback
      end
    end
  end
  alias_method_chain :save, :login

  protected
  def set_name_from_login
    self.name = login.username if name.blank? and login
  end
  before_validation :set_name_from_login
  def login_attributes=(attributes)
    build_login unless login
    login.attributes, login.user = attributes, self
  end
  def local_path
    page.path if page
  end
  def remote_url
    url unless url.blank?
  end

  def format_url
    self.url = "http://#{ url }" unless url.blank? or url =~ /^https?:\/\//
  end
  protected :format_url
  before_save :format_url

end
