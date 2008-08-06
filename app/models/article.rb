class Article < ActiveRecord::Base

  belongs_to :author, :class_name => 'User'

  has_one :publication, :as => :publishable, :dependent => :delete
  has_many :comments, :as => :commented, :dependent => :delete_all

  validates_presence_of :title, :head, :body

  def self.find_all_public(options)
    options = options.merge :joins => :publication,
      :conditions => ['publications.created_at < ?', Time.now]

    find :all, options
  end

  def self.find_public(id, options)
    options = options.merge :joins => :publication, :conditions => [
      'publications.created_at < ? AND articles.id = ?',
      Time.now, id
    ]

    find :first, options
  end

  def self.find_by_ident(ident, options = {})
    find_public ident.to_i, options or Page.not_found
  end
  def ident
    "#{ id }-#{ title.downcase.gsub /[ \.]/, '-' }"
  end

  def to_s
    self[:title]
  end

end
