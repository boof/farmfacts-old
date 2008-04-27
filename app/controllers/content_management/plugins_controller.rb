class ContentManagement::PluginsController < ContentManagement::Base
  
  cache_sweeper :plugin_sweeper, :only => [:create, :update, :destroy]
  
  def index
    @plugins = Plugin.find :all, :order => :name
    @page_title = 'Content Management - Plugins'
  end
  
  def new
    @plugin ||= Plugin.new
    @page_title = 'Content Management - New Plugin'
    
    render :action => :new
  end
  
  def edit
    @plugin ||= Plugin.find params[:id]
    @page_title = "Content Management - Edit Plugin '#{ @plugin.name }'"
    
    render :action => :edit
  end
  
  def create
    @plugin = Plugin.new params[:plugin]
    
    user.will :save, @plugin do |saved|
      if saved
        redirect_to :action => :index
      else
        send :new
      end
    end
  end
  
  def update
    @plugin = Plugin.find params[:id]
    @plugin.attributes = params[:plugin]
    
    user.will :save, @plugin do |saved|
      if saved
        redirect_to :action => :index
      else
        send :edit
      end
    end
  end
  
  def destroy
    user.will :destroy, Plugin.find( params[:id] )
    redirect_to :action => :index
  end
  
end
