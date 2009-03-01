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
      load_target
      proxy_target.inject('') { |buf, el| buf << el.to_s(:completed) }
    end
    # Returns element with theme assigned.
    def load(name)
      load_target

      element = proxy_owner.theme.element name
      element.themed_page = proxy_owner
      proxy_target << element

      element
    end
  end

  def locale
    metadata['language']
  end

  def doctype
    theme.doctype
  end

  def head(target)
    theme.to_s :head, :page => self, :target => target
  end

  def body(target)
    theme.to_s :body, :elements => elements, :target => target
  end

  protected
  def generate_name
    self.name = title.parameterize if name.blank?
  end
  before_save :generate_name

end
