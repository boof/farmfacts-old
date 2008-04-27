# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  protect_from_forgery
  filter_parameter_logging %w[password]
  include ExceptionNotifiable
  
  protected
  def not_found(page)
    render :text => page.body, :layout => true, :status => 404
  end
  
end
