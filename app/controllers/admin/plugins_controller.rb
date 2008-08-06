class Admin::PluginsController < Admin::Base

  PAGE_TITLES = {
    :index  => 'Plugins',
    :new    => 'New Plugin',
    :edit   => 'Edit "%s"'
  }

  before_filter :assign_new_plugin,
    :only => [:new, :create]
  before_filter :assign_plugin_by_id,
    :only => [:edit, :update, :destroy]

  cache_sweeper :plugin_sweeper, :only => [:create, :update, :destroy]

  def index
    title_page :index
    @plugins = Plugin.find :all, :order => :name
  end

  def new
    title_page :new
    render :action => :new
  end

  def edit
    title_page :edit, @plugin
    render :action => :edit
  end

  def create
    @plugin.attributes = params[:plugin]

    current_user.will :save, @plugin do |saved|
      if saved
        redirect_to :action => :index
      else
        send :new
      end
    end
  end

  def update
    @plugin.attributes = params[:plugin]

    current_user.will :save, @plugin do |saved|
      if saved
        redirect_to :action => :index
      else
        send :edit
      end
    end
  end

  def destroy
    current_user.will :destroy, @plugin
    redirect_to :action => :index
  end

  protected
  def assign_new_plugin
    @plugin = Plugin.new
  end
  def assign_plugin_by_id
    @plugin = Plugin.find params[:id]
  end

end
