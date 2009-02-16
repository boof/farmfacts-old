class Polymorphism

  attr_reader :base, :ctrl, :path
  cattr_reader :polymorph, :polymorphs, :namespace

  def self.inherited(base)
    basename = base.name
    basename.slice! -12, 12 if basename[-12, 12] == 'Polymorphism'
    basename = basename.underscore

    unless basename_index = basename.rindex('/')
      namespace = []
    else
      namespace = basename.slice!(0, basename_index).split '/'
      basename.slice! 0, 1
    end

    base.module_eval do
      class_variable_set :@@namespace, namespace
      class_variable_set :@@polymorph, "#{ basename }"
      class_variable_set :@@polymorphs, "#{ basename }".pluralize
    end
  end

  def initialize(ctrl)
    @ctrl, @key   = ctrl, ctrl.params.keys.find { |key| key =~ /(.+)_id$/ }
    @base, @path  = $~[1], Path.new(self)
  end

  def proxy_target_id
    @ctrl.params[:id]
  end
  def proxy_target_class
    @proxy_target_class ||= @@polymorph.classify.constantize
  end
  def proxy_owner_id
    @ctrl.params[@key]
  end
  def proxy_owner_class
    @proxy_owner_class ||= @base.classify.constantize
  end
  def association_reflection
    @association_reflection ||=
      proxy_owner_class.reflect_on_association(@@polymorph.to_sym) ||
      proxy_owner_class.reflect_on_association(@@polymorphs.to_sym)
  end
  def singular?
    association_reflection.macro == :has_one
  end
  def plural?()
    association_reflection.macro == :has_many
  end

  def proxy_owner
    proxy_owner_class.find proxy_owner_id
  end
  def proxy
    proxy_owner.send association_reflection.name
  end
  def proxy_target
    proxy_target_class.find proxy_target_id
  end
  def proxy_collection
    proxy_target_class.find :all, :conditions => {
      "#{ association_reflection.as }_type" => proxy_owner_class.base_class.name,
      "#{ association_reflection.as }_id"   => proxy_owner_id
    }
  end

  class Path
    def initialize(polymorphism)
      @polymorphism = polymorphism
    end

    def index
      generate nil, polymorphs
    rescue
      generate nil, polymorph
    end
    def show(proxy_target = @polymorphism.proxy_target)
      generate nil, proxy_target
    end
    def new
      generate :new, proxy_target_class.new
    end
    def edit(proxy_target = @polymorphism.proxy_target)
      generate :edit, proxy_target
    end

    def collection(action, *args)
      prefix = ''
      prefix << "#{ action }_" if action
      prefix << "#{ namespace * '_' }_" if namespace

      ctrl.send :"#{ prefix }#{ base }_#{ polymorphs }_path",
        proxy_owner, *args
    end

    def generate(action = nil, *args)
      action &&= "#{ action }_"
      ctrl.send :"#{ action }polymorphic_path",
          [namespace, proxy_owner, args].flatten!
    end

    protected
    def base
      @polymorphism.base
    end
    def polymorph
      @polymorphism.polymorph
    end
    def polymorphs
      @polymorphism.polymorphs
    end
    def namespace
      @polymorphism.namespace
    end
    def ctrl
      @polymorphism.ctrl
    end
    def proxy_owner
      @polymorphism.proxy_owner
    end
    def proxy_target_class
      @polymorphism.proxy_target_class
    end
  end

end
