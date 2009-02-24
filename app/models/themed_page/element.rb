class ThemedPage::Element < ActiveRecord::Base
  set_table_name 'themed_page_elements'

  acts_as_list :scope => :themed_page
  default_scope :order => 'position'

  attach_shadows :assigns => :data
  serialize :data

  belongs_to :themed_page
  attr_writer :theme
  def theme() @theme ||= themed_page.theme end

  composed_of :pathname, :mapping => [ %w[ path to_s ] ],
    :class_name => 'Pathname',
    :constructor => proc { |path| Pathname.new "#{ path }" },
    :converter => proc { |path| Pathname.new "#{ path }" }

  def name
    "#{ pathname.basename }"
  end

  def icon
    theme.icon_for self
  end

  protected
  def pagify_page
    themed_page.update_attribute :updated_at, updated_at
  end
  after_save :pagify_page

end
