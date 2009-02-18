class TemplatedPage::Element < ActiveRecord::Base
  set_table_name 'templated_page_elements'

  acts_as_list :scope => :templated_page
  default_scope :order => 'position'

  belongs_to :templated_page

  def render(data)
    # render ActionView at :path with data assigned
  end

end
