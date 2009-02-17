class Template < ActiveRecord::Base

  # source directory
  TEMPLATE_PATH = Rails.root.join 'vendor', 'templates'

  # Returns a Filepath object pointing to the templates source directory.
  def self.path
    TEMPLATE_PATH
  end

  validates_uniqueness_of :name

  has_many :templated_pages

  has_many :attachments, :as => :attaching, :dependent => :destroy do
    def as_defined(definition)
      proxy_owner.attachments.build do |attachment|
        # assign attachable file
        attachable_path = Template.path.join proxy_owner.name, definition['path']
        File.open(attachable_path) { |able| attachment.attachable = able }

        # assign type for Single Table Inheritance
        type = definition['type'] and
        attachment.type = "Attachment::#{ type }"

        # assign disposition
        attachment.disposition = definition['disposition']
      end
    end
  end
  has_many :javascripts, :as => :attaching, :class_name => 'Attachment', :conditions => ['attachments.type IN (?)', %w[ Attachment::Javascript ]]
  has_many :stylesheets, :as => :attaching, :class_name => 'Attachment', :conditions => ['attachments.type IN (?)', %w[ Attachment::Stylesheet Attachment::Stylesheet::IE ]]

  # Returns true when this template is already installed.
  def installed?() true end

  # Builds defined attachments into template.
  def build_attachments(definitions)
    definitions.each { |definition| attachments.as_defined definition }
  end

  # Loads named template from source directory.
  def self.load(name)
    definitions_path = path.join "#{ name }.yaml"
    definition = YAML.load_file definitions_path

    new do |template|
      template.name     = name
      template.caption  = definition['caption'] || name.humanize
      template.build_attachments definition['attachments']

      # overwrite method to indicate that this template is not installed
      def template.installed?() false end
    end
  end

  # Returns a hash with all templates which are installed.
  def self.installed
    find(:all).inject({}) { |m, t| m.merge! t.name => t }
  end
  # Returns a hash with all templates which aren't already installed.
  def self.not_installed
    loaded = select_all(:name).inject({}) { |m, n| m.merge! n => true }

    Dir[ path.join('*') ].inject({}) do |templates, template_name|
      template_name = File.basename template_name # strip directories
      template_name = template_name[/^[^\.]+/] # strip extensions

      # load template and mark it as loaded, unless it's already loaded
      loaded[template_name] ||=
          ( templates[template_name] = Template.load template_name )

      templates
    end
  end

  # Returns a hash with all templates.
  def self.available
    installed.merge! not_installed
  end

  def elements
    raise NotImplementedError, 'TODO: implement elements method'
  end

end
