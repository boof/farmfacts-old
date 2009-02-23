class ThemedPage < ActiveRecord::Base

  validates_presence_of :theme_id, :title
  belongs_to :theme

  include Pagificator
  categorizable

  has_many :elements, :class_name => 'ThemedPage::Element', :dependent => :delete_all do
    def available
      proxy_owner.theme.elements
    end
    def render
      reload
      proxy_target.inject('') { |buf, el| buf << el.to_s(:completed) }
    end
    # Returns element with theme assigned.
    def load(name)
      load_target

      element = proxy_owner.theme.element name
      element.themed_page = proxy_owner
      element.data = {}
      proxy_target << element

      element
    end
  end

  def language
    metadata['language']
  end

  def doctype
    theme.doctype
  end

  def head
    theme.to_s :head, :page => self
  end

  def body
    theme.to_s :body, :content => elements.render
  end

  protected
  def sanitize_path
    if path.blank?
      self.path = "/#{ title.parameterize }.#{ language }"
    elsif path[0, 1] != '/'
      self.path = "/#{ path }"
    end
  end
  before_save :sanitize_path

end
