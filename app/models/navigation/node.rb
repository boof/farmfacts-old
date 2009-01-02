class Navigation::Node < ActiveRecord::Base

  extend Bulk::Destroy
  self.table_name = 'navigation_nodes'

  uses_registered_path
  belongs_to :container, :class_name => 'Navigation::Container'
  acts_as_list :scope => :container

  def render
    %Q'<div class="#{ html_class }">#{ render_content }</div>'
  end
  def render_content
    url.blank?? content : %Q'<a href="#{ url }">#{ content }</a>'
  end

  protected
  def set_url
    self.url = registered_path.path if registered_path_id
  end
  before_save :set_url

  protected
  def update_container
    container.update_attribute :updated_at, updated_at
  end
  after_save :update_container

end
