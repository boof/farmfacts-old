class ThemedPage < Page

  validates_presence_of :theme_id
  belongs_to :theme

  has_many :elements, :class_name => 'ThemedPage::Element' do
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
