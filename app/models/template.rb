require 'forwardable'

class Template
  extend Forwardable

  # template_a == template_b
  def ==(other)
    name == other.name
  end

  # Template.templates # => [<Template:a34b8f12 atribute_a="...">, <Tem...]
  def self.templates
    templates = Set.new
    path = Rails.root.join 'vendor', 'templates', '*'
    Dir[ path ].each do |template_path|
      # FIXME: create template unless it's already in set
      template = Template.new File.basename(template_path)[/^([^\.]+)/, 1]
      templates << template
    end
  end

  # Template[template_name] # => <Template:a34b8f12 atribute_a="...">
  # Template.find template_name # => <Template:a34b8f12 atribute_a="...">
  def_delegator :templates, :[]
  def_delegator :templates, :[], :find

  def self.new(name)
    # read yaml
    # read and extend attachments
    # read elements

    instance = allocate
    instance.initialize name, attachments, elements
    instance
  end
  def initialize(name, attachments, elements)
    @name, @attachments, @elements = name, attachments, elements
  end

  # simulates has_many(:templated_pages)
  def templated_pages
    TemplatedPage.scoped :conditions => { :template_name => @name }
  end

  def javascripts
    @javascripts ||= @attachments.select { |att| att.is_a? Attachment::Javascript::Extension }
  end
  def stylesheets
    @stylesheets ||= @attachments.select { |att| att.is_a? Attachment::Stylesheet::Extension }
  end
  def elements
    @elements
  end

end
