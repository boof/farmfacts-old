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

  serialize :body, Array
  # Returns a string with all elements completed.
  def body
    buffer = ''
    0.upto(self[:body].length) { |index| buffer << elements[index] }

    buffer
  end

end
