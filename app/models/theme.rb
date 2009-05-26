class Theme < ActiveRecord::Base; CLASS = self

  validates_uniqueness_of :name

  has_many :templates, :class_name => 'Theme::Template', :dependent => :delete_all

  has_many :compositions, :class_name => 'Page::Composition', :dependent => :delete_all
  has_many :pages, :through => :compositions do
    def rebuild
    end
  end

  has_many :attachments, :as => :attaching, :dependent => :destroy do
    def root
      @directory ||= proxy_owner.path.join 'attachments'
    end
    def restore
      begin
        clear and read_directory root
      rescue
        STDERR.puts $!
      end
    end
    protected
    def setup(filename)
      @builder ||= proxy_owner.definition.attachments
      @builder.build directory + filename
    end
    def read_directory(parent_path)
      parent_path.each_entry do |entry|
        next if %w[ . .. ].include? entry.to_s

        absolute_path = parent_path.join entry
        if absolute_path.file?
          self << setup(absolute_path)
        elsif absolute_path.directory?
          read_directory absolute_path
        end
      end
    end
  end

  # path themes can be installed from
  PATH = Rails.root

  # Returns a Theme::List for all themes from <tt>relative_path</tt>.
  def self.fetch(relative_path)
    CLASS::List.new find_in_path(relative_path)
  end
  # Returns a Theme::List for all themes stored in DB.
  def self.installed
    CLASS::List.new find(:all)
  end

  # Returns true if named theme was successfully installated from
  # <tt>relative_path</tt>.
  def self.install(name, relative_path = 'vendor/themes')
    fetch(relative_path)[name].install
  end
  # Returns true if named theme was successfully uninstalled.
  def self.uninstall(name)
    installed[name].uninstall
  end
  class << self
    extend ActiveSupport::Memoizable and memoize :fetch
  end

  alias_method :install, :save
  alias_method :uninstall, :destroy

  # Returns true when this theme is installed.
  def installed?
    !new_record? or CLASS::exists? :name => name
  end

  # Restores attachments and optionally rebuilds associated pages.
  def repair(rebuild_pages = true)
    repaired = installed?

    repaired &&= attachments.restore
    repaired &&= pages.rebuild if rebuild_pages

    repaired
  end

  def path(extname)
    CLASS::path.join "#{ name }#{ extname }"
  end

  # Returns a Theme::Definition for this theme.
  def definition
    @definition ||= CLASS::Definition.load path('.yml')
  end

  protected
  def self.read_package(relative_path, path_prefix)
    raise NotImplementedError
    # read definition
    # build Theme

    # the next should be lazy-loaded have a state...
    # read attachments
    # assign attachments to theme
    # read templates
    # assign templates to theme
  end
  def self.read_yaml(relative_path, path_prefix)
    definition = CLASS::Definition.load path_prefix + relative_path
  end
  def self.find_in_path(path)
    path = Pathname.new path unless Pathname == path
    return false if path.absolute?

    path = PATH + path
    return false unless path.directory?

    themes = []

    path.each_entry do |entry|
      case entry.extname
      when '.fat'; themes << read_package(entry, path)
      when '.yml'; themes << read_yaml(entry, path)
      end
    end

    themes
  end

end
