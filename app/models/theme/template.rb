class Theme::Template < ActiveRecord::Base
  set_table_name 'theme_templates'

  belongs_to :theme
  validates_presence_of :theme_id

  acts_as_list :scope => :theme
  default_scope :order => 'position'

end
