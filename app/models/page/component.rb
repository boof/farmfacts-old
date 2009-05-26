class Page::Component < ActiveRecord::Base
  set_table_name 'page_components'

  belongs_to :template, :class_name => 'Theme::Template'
  validates_presence_of :template_id
  belongs_to :composition, :class_name => 'Page::Composition'
  validates_presence_of :composition_id

  acts_as_list :scope => :composition
  default_scope :order => 'position'

  protected
  def touch_composition
    composition.touch
  end
  after_save :touch_composition

end
