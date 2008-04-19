class PluginsController < ApplicationController
  
  def index
    @plugins = Plugin.find :all, :order => :name
    
    respond_to do |wants|
      wants.html
      wants.js
    end
  end
  
end
