class Article < ActiveRecord::Base

  extend Bulk::Destroy
#  extend Bulk::Publication

  belongs_to :author, :class_name => 'User'

  on_whitelist :updates => :updated_at
  has_many :comments, :as => :commented, :dependent => :delete_all

  named_scope :with_order, proc { |*columns|
    {:order => columns.blank?? 'articles.created_at DESC' : [*columns] * ', '}
  }

  validates_presence_of :title, :introduction, :body
  has_friendly_id :title, :use_slug => true, :strip_diacritics => true

  def to_s
    title
  end

  def published_at(timezone = nil)
    if timezone
      ActiveSupport::TimeWithZone.new publication.created_at, timezone
    else
      publication.created_at
    end
  end

end
