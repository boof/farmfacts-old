class PluginsController < ApplicationController
  
  caches_page :index, :show
  
  def index
    @plugins = Plugin.find :all, :order => :name
  end
  
  def show
    @plugin = Plugin.find params[:id]
  end
  
  def feed
    respond_to do |wants|
      wants.html  { render :nothing => true, :status => 400 }
      wants.js    { @feed = Plugin.feed_for params[:id] }
    end
  end
  
end
