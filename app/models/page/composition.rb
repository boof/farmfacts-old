class Page::Composition < ActiveRecord::Base
  set_table_name 'page_compositions'

  belongs_to :page
  validates_presence_of :page_id
  belongs_to :theme
  validates_presence_of :theme_id

  has_many :components, :class_name => 'Page::Component', :dependent => :delete_all

  def touch
    update_attribute :updated_at => Time.now
  end

  protected
  def mark_page
    page.expire
  end
  after_save :mark_page

end
