class ThemedPage < Page

  validates_presence_of :theme_id
  belongs_to :theme

  has_many :elements, :class_name => 'ThemedPage::Element' do
    def rendered
      load_target
      index = 0

      self[:body].map { |data|
        rendered_element = proxy_target[index].try :render, data
        index += 1
        rendered_element
      }
    end
    # Returns element with theme assigned.
    def load(name)
      proxy_owner.theme.element name
    end
    # Returns completed element on index.
    def [](index)
      load_target
      proxy_target[index].try :render, proxy_owner[:body][index]
    end
  end

  # Returns attached javascripts from theme and self.
  def javascripts
    theme.javascripts + super
  end
  # Returns attached stylesheets from theme and self.
  def stylesheets
    theme.stylesheets + super
  end

  serialize :body
  # Returns a string with all elements rendered.
  def body
    buffer = ''
    self[:body].length.times { |index| buffer << elements[index] }

    buffer
  end

end
