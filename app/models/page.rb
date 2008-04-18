class Page < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  
  def self.find_by_name(name)
    find :first, :conditions => {:name => name} or
    raise ActiveRecord::RecordNotFound, "`#{name}' not found for Page"
  end
  
  validates_uniqueness_of :name
  validates_presence_of :title, :body_textile
  
  before_save :textilize_body
  
  protected
  def textilize_body
    self[:body] = textilize_without_paragraph self[:body_textile]
  end
  
end
