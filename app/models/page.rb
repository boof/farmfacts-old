class Page < ActiveRecord::Base

  attr_accessor :old_name

  has_one :publication, :as => :publishable, :dependent => :delete
  has_many :comments, :as => :commented, :dependent => :delete_all

  def self.find_public_by_name(name)
    find :first, :joins => :publication,
      :conditions => [
        'publications.created_at < ? AND pages.name = ?',
        Time.now, name
      ]
  end

  def self.not_found
    find :first, :conditions => {:name => '/not_found'} or
    new :name => '/not_found'
  end

  def self.name_by_id(id)
    find(id, :select => :name).name rescue nil
  end

  def self.find_by_name(name)
    find_public_by_name name or not_found
  end

  validates_uniqueness_of :name
  validates_presence_of :title, :body
  validates_format_of :name, :with => /[a-z]+/

  def not_found?
    self[:name] == '/not_found'
  end
  def homepage?
    self[:name] == '/home'
  end

  def to_s
    self[:title]
  end

  protected
  def slash_name
    self[:name].insert(0, '/') if self[:name][0, 1] != '/'
  end
  before_save :slash_name

end
