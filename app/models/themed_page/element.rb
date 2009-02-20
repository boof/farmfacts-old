class ThemedPage::Element < ActiveRecord::Base
  set_table_name 'themed_page_elements'

  acts_as_list :scope => :themed_page
  default_scope :order => 'position'

  attach_shadows

  belongs_to :themed_page
  attr_accessor :theme

  composed_of :pathname, :mapping => [ %w[ path to_s ] ],
    :class_name => 'Pathname',
    :constructor => proc { |path| Pathname.new "#{ path }" },
    :converter => proc { |path| Pathname.new "#{ path }" }

  def name
    "#{ pathname.basename }"
  end

end
