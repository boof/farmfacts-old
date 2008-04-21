class Page < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  
  has_one :publication, :as => :publishable, :dependent => :destroy
#  has_many :comments, :as => :commented, :dependent => :destroy
  
  def self.find_public_by_name(name)
    find :first, :include => :publication,
      :conditions => {'publications.revoked' => false, :name => name}
  end
  
  def self.not_found
    find :first, :conditions => {:name => 'not_found'}
  end
  
  def self.find_by_name(name)
    find_public_by_name(name) or not_found
  end
  
  validates_uniqueness_of :name
  validates_presence_of :title, :body_markdown
  
  def to_s
    self[:title]
  end
  
  def markdown_body
    self[:body] = markdown self[:body_markdown]
  end
  before_save :markdown_body
  
end
