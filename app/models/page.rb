class Page < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  
  def self.find_by_name(name)
    find :first, :conditions => {:name => name} or
    find :first, :conditions => {:name => 'not_found'}
  end
  
  validates_uniqueness_of :name
  validates_presence_of :title, :body_markdown
  
  before_save :markdown_body
  
  protected
  def markdown_body
    self[:body] = markdown self[:body_markdown]
  end
  
end
