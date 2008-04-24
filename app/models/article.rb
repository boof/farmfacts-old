class Article < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  
  belongs_to :author, :class_name => 'User'
  
  has_one :publication, :as => :publishable, :dependent => :destroy
  has_many :comments, :as => :commented, :dependent => :destroy
  
  
  
  def self.find_all_public(options)
    options = options.merge :include => :publication,
      :conditions => {'publications.revoked' => false}
    
    find :all, options
  end
  
  def self.find_public(id, options)
    options = options.merge :include => :publication,
      :conditions => {'publications.revoked' => false}
    
    find id, options
  end
  
  def self.find_by_ident(ident, options = {})
    find_public ident.to_i, options or Page.not_found
  end
  def ident
    "#{ id }-#{ title.downcase.gsub ' ', '-' }"
  end
  def is_not_found?
    false
  end
  def to_s
    self[:title]
  end
  
  def announce(editor, recipients, prefix = '')
    recipients.split(',').each do |recipient|
      Announce.deliver_article editor, recipient, self, prefix
    end
  end
  
  SPLITTER = '</p>'
  def markdown_content
    content = markdown self[:content_markdown]
    self[:head], self[:body] = content.split(SPLITTER, 2).map(&:strip)
    self[:head] << SPLITTER
  end
  before_save :markdown_content
  
end
