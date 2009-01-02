class Navigation::Container < ActiveRecord::Base

  self.table_name = 'navigation_containers'

  has_many :nodes, :class_name => 'Navigation::Node', :order => :position do
    def render
      output = ''
      for node in proxy_owner.nodes
        output << node.render
      end
      output
    end
  end

  validates_uniqueness_of :element_id
  validates_format_of :element_id, :with => /\A[a-z0-9]+\Z/i
  serialize :html_attributes, Hash

  def self.cache_name(element_id)
    File.join 'navigations', element_id
  end
  def cache_name
    self.class.cache_name element_id
  end

  def self.render(element_id)
    Rails.cache.read cache_name(element_id) or
    find(:first, :conditions => {:element_id => element_id}).try :render!
  end

  def render
    Rails.cache.read cache_name or render!
  end
  def render!
    Rails.cache.
        write cache_name, "<div #{ render_attributes }>#{ nodes.render }</div>"
  end

  def to_s
    element_id
  end

  protected
  def render_attributes
    output = %Q'id="#{ element_id }"'
    for key, value in html_attributes
      output << %Q' #{ key }="#{ value }"'
    end
    output
  end

  if connection.respond_to? :sqlite_version # then it sucks hard!
    default_attributes = columns_hash['html_attributes'].default
    default_attributes = default_attributes.slice 1, default_attributes.length - 2

    columns_hash['html_attributes'].
        instance_variable_set :@default, default_attributes
  end

end
