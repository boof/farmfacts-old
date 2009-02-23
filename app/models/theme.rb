class Theme < ActiveRecord::Base

  attach_shadows

  # source directory
  THEME_PATH = Rails.root.join 'vendor', 'themes'

  # Returns a Filepath object pointing to the theme source directory.
  def self.path
    THEME_PATH
  end

  # Returns a Filepath object pointing to this themes source directory.
  def path
    THEME_PATH.join name
  end

  # FIXME: validates_uniqueness_of :name

  # TODO: complete this stub with Attachment::Icon.attachable
  def icon_path
    'thumbnails/themed_page.png' # fallback
  end

  has_many :themed_pages
  def downgrade_themed_pages
    ThemedPage.destroy_all ['id IN (?)', themed_page_ids]
  end
  after_destroy :downgrade_themed_pages

  has_many :attachments, :as => :attaching, :dependent => :destroy do
    def as_defined(definition)
      build do |attachment|
        # assign attachable file
        attachable_path = proxy_owner.path.join definition['path']
        File.open(attachable_path) { |able| attachment.attachable = able }

        # assign type for Single Table Inheritance
        type = definition['type'] and
        attachment.type = "Attachment::#{ type }"

        # assign disposition
        attachment.disposition = definition['disposition']
      end
    end
  end
  delegate :javascripts, :stylesheets, :element_icons, :to => :attachments

  # Returns true when this theme is already installed.
  def installed?() true end

  # Builds defined attachments into theme.
  def build_attachments(definitions)
    definitions.each { |definition| attachments.as_defined definition }
  end

  # Loads named theme from source directory.
  def self.load(name)
    definitions_path = path.join "#{ name }.yaml"
    definition = YAML.load_file definitions_path

    new do |theme|
      theme.name    = name
      theme.caption = definition['caption'] || name.humanize
      theme.doctype = DOC_TYPES.find { |d| d[0] == definition['doctype'] }[1]
      theme.build_attachments definition['attachments']

      # overwrite method to indicate that this theme is not installed
      def theme.installed?() false end
    end
  end

  # Returns a hash with all themes which are installed.
  def self.installed
    find(:all).inject({}) { |m, t| m.merge! t.name => t }
  end
  # Returns a hash with all themes which aren't already installed.
  def self.not_installed
    loaded = select_all(:name).inject({}) { |m, n| m.merge! n => true }

    Dir[ path.join('*') ].inject({}) do |themes, theme_name|
      theme_name = File.basename theme_name # strip directories
      theme_name = theme_name[/^[^\.]+/] # strip extensions

      # load theme and mark it as loaded, unless it's already loaded
      loaded[theme_name] ||=
          ( themes[theme_name] = load theme_name )

      themes
    end
  end

  # Returns a hash with all themes.
  def self.available
    installed.merge! not_installed
  end

  def icon_for(element)
    element_icons.first :conditions => { :disposition => element.name }
  end

  def element(index_or_name)
    path = case index_or_name
        when Integer; element_paths[index_or_name]
        when String, Symbol; element_path index_or_name
        else raise ArgumentError, 'expected string, symbol or integer'
        end

    element_cache[path]
  end
  def elements
    element_paths.map { |path| element_cache[path] }
  end

  protected
  def element_names
    @element_names ||= YAML.load_file path.join('elements.yaml')
  end
  def element_path(name)
    path.join('elements', name)
  end
  def element_paths
    element_names.map { |name| element_path name }
  end
  def element_cache
    @element_cache ||= Hash.new { |cache, pathname|
      attributes = { :pathname => pathname, :theme => self }
      cache[pathname] = ThemedPage::Element.new attributes
    }
  end

end
