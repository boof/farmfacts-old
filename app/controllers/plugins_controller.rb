class PluginsController < ApplicationController
  
  def index
    @plugins = Plugin.find :all, :order => :created_at
    
    respond_to do |wants|
      wants.html
      wants.js { render :text => :foo }
    end
  end
  
end
