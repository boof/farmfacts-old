class Article < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  
  belongs_to :author, :class_name => 'User'
  
  has_one :publication, :as => :publishable, :dependent => :delete
  has_many :comments, :as => :commented, :dependent => :delete_all
  
  def self.find_all_public(options)
    options = options.merge :joins => :publication,
      :conditions => {'publications.revoked' => false}
    
    find :all, options
  end
  
  def self.find_public(id, options)
    options = options.merge :joins => :publication, :conditions => {
      'articles.id' => id,
      'publications.revoked' => false
    }
    
    find :first, options
  end
  
  def self.find_by_ident(ident, options = {})
    find_public ident.to_i, options or Page.not_found
  end
  def ident
    "#{ id }-#{ title.downcase.gsub /[ \.]/, '-' }"
  end
  
  def not_found?
    false
  end
  def to_s
    self[:title]
  end
  
  SPLITTER = '</p>'
  def markdown_content
    content = markdown self[:content_markdown]
    self[:head], self[:body] = content.split(SPLITTER, 2).map(&:strip)
    self[:head] << SPLITTER
  end
  before_save :markdown_content
  
end
