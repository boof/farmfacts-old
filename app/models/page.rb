class Page < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  
  has_one :publication, :as => :publishable
#  has_many :comments, :as => :commented
  
  def self.find_public_by_name(name)
    find :first, :include => :publication,
      :conditions => {'publications.revoked' => false, :name => name}
  end
  
  def self.find_by_name(name)
    find_public_by_name(name) or
    find :first, :conditions => {:name => 'not_found'}
  end
  
  validates_uniqueness_of :name
  validates_presence_of :title, :body_markdown
  
  def markdown_body
    self[:body] = markdown self[:body_markdown]
  end
  before_save :markdown_body
  
end
