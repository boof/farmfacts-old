class Project < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  categorizable

  has_many :roles, :as => :work
  has_many :users, :through => :roles
  has_many :attachments, :as => :attaching, :dependent => :delete_all

  belongs_to :attachment
  def icon
    ( attachment || build_attachment ).attachable
  end

  validates_uniqueness_of :name
  validates_presence_of :name

  belongs_to :page

  def to_s
    name
  end

  def category_names=(names)
    names = category_name_divider.split "#{ names }"
    names << name unless names.include? name
    super names * "#{ category_name_divider } "
  end

  def website
    local_path or remote_url or github_url
  end

  def github?
    not github_repository.blank?
  end
  def github
    GitHub::Repository.build github_repository if github?
  end
  memoize :github

  protected
  def local_path
    page.path if page
  end
  def remote_url
    url unless url.blank?
  end
  def github_url
    github and github.url
  end

  def format_url
    self.url = "http://#{ url }" unless url.blank? or url =~ /^https?:\/\//
  end
  protected :format_url
  before_save :format_url

end
