class TemplatedPage < Page

  validates_presence_of :template_id
  belongs_to :template

  has_many :elements, :class_name => 'TemplatedPage::Element' do
    # Returns completed element on index.
    def [](index)
      load_target
      proxy_target[index].try :render, proxy_owner[:body][index]
    end
  end

  # Returns attached javascripts from template and self.
  def javascripts
    template.javascripts + super
  end
  # Returns attached stylesheets from template and self.
  def stylesheets
    template.stylesheets + super
  end

  serialize :body
  # Returns a string with all elements rendered.
  def body
    buffer = ''
    self[:body].length.times { |index| buffer << elements[index] }

    buffer
  end

end
