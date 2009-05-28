class Page::Component < ActiveRecord::Base
  set_table_name 'page_components'

  belongs_to :template, :class_name => 'Theme::Template'
  validates_presence_of :template_id
  belongs_to :composition, :class_name => 'Page::Composition', :touch => true
  validates_presence_of :composition_id

  acts_as_list :scope => :composition
  default_scope :order => 'position'

end
